# shellcheck shell=sh

status_dotfiles() {
	set -- \
		--modified \
		--others \
		--exclude-standard \
		--directory \
		--no-empty-directory
	if [ -n "$(dotfiles ls-files "$@" || true)" ] ||
		! dotfiles submodule foreach \
			"[ -z \"\$(git ls-files ""$*"")\" ]" \
			>/dev/null 2>/dev/null; then
		echo "In dotfiles:"
		dotfiles status -s
		dotfiles submodule foreach 'git status -s'
		return 1
	fi
}

print_goodbye() {
	if [ -z "${TMUX}" ]; then
		status_dotfiles || read -r _
	fi
}

status_news() {
	output_email="$(
		for path in "${XDG_DATA_HOME}/mail/"*; do
			mailbox=$(basename "${path}")

			count_spam_new=$(find "${path}/[Gmail]/Spam/new" -type f | wc -l)
			count_spam_cur=$(find "${path}/[Gmail]/Spam/cur" -type f | wc -l)
			count_spam="$((count_spam_new + count_spam_cur))"

			count_new=$(find "${path}/Inbox/new" -type f | wc -l)
			count_cur=$(find "${path}/Inbox/cur" -type f | wc -l)
			count_cur_unseen=$(find "${path}/Inbox/cur" -type f | grep -cv "S[^,]*$")
			count_unseen="$((count_new + count_cur_unseen))"
			count="$((count_new + count_cur))"

			if [ "$((count + count_spam))" -gt 0 ]; then
				echo "${count_new}/${count_unseen}/${count}-${count_spam}" "${mailbox}"
			fi
		done
	)"
	unset mailbox count
	if [ -n "${output_email}" ]; then
		echo "# Email"
		echo "${output_email}" | column
		echo
	fi
	unset output_email

	sql_output=$(mktemp)
	tags=$(mktemp)
	echo "SELECT feedurl, SUM(unread) FROM rss_item GROUP BY feedurl" |
		sqlite3 ~/.local/share/newsboat/cache.db |
		sort >"${sql_output}"
	awk '! (/^#/ || /^$/) { print $1 "|" $2 }' ~/.config/newsboat/urls |
		sed "/\"/d" |
		sort -u >"${tags}"
	output_rss="$(
		join -t "|" "${sql_output}" "${tags}" |
			awk -F "|" '{ arr[$3] += $2 } END { for (key in arr) if (arr[key] > 0) printf("%d %s\n", arr[key], key) }'
	)"
	rm -f "${sql_output}" "${tags}"
	unset sql_output tags
	if [ -n "${output_rss}" ]; then
		echo "# RSS"
		echo "${output_rss}" | column
		echo
	fi
	unset output_rss

}

check_imca() {
	current_date="$(date +%s)"

	if [ -f /tmp/check_imca ]; then
		if [ "$(cat /tmp/check_imca || true)" -ne 200 ]; then
			next_check="$(($(stat -c %Y "/tmp/check_imca") + 1 * 60))"
		else
			next_check="$(($(stat -c %Y "/tmp/check_imca") + 15 * 60))"
		fi
	else
		next_check="${current_date}"
	fi

	if [ "${current_date}" -ge "${next_check}" ]; then
		curl -s -o /dev/null -w "%{http_code}" imca.edu.pe/es/ >/tmp/check_imca
	fi

	status_code="$(cat /tmp/check_imca)"
	if [ "${status_code}" -ne 200 ]; then
		echo "imca.edu.pe/es/ status code ${status_code}"
	fi
	unset status_code
}

check_exchange_rate() {
	current_date="$(date +%s)"

	if [ -f /tmp/check_exchange_rate ]; then
		if [ -z "$(cat /tmp/check_exchange_rate || true)" ]; then
			next_check="$(($(stat -c %Y "/tmp/check_exchange_rate") + 1 * 60))"
		else
			next_check="$(($(stat -c %Y "/tmp/check_exchange_rate") + 15 * 60))"
		fi
	else
		next_check="${current_date}"
	fi

	if [ "${current_date}" -ge "${next_check}" ]; then
		response=$(
			curl -sS https://cuantoestaeldolar.pe/cambio-de-dolar-online |
				sed "s/class>/>/g;s/class //g;s/defer //g;s/alt //g;s/defer>/>/g;s/data-n-p//g;s/data-n-g//g;s/data-n-css//g;s/nomodule //g" |
				xpath -q -e "/html/body/div/main/div[3]/div/div[7]/div/div[1]" 2>/dev/null
		)

		buy=$(
			for i in $(seq 26); do
				exchange=$(echo "${response}" | xpath -q -e "/div/div[${i}]/div[1]/div[6]/div/div[1]/p" 2>/dev/null | sed 's/<[^>]*>//g')
				[ "${exchange}" != "0.000" ] && [ -n "${exchange}" ] && echo "${exchange}"
			done | sort | tail -n 1
		)

		sell=$(
			for i in $(seq 26); do
				exchange=$(echo "${response}" | xpath -q -e "/div/div[${i}]/div[1]/div[6]/div/div[2]/p" 2>/dev/null | sed 's/<[^>]*>//g')
				[ "${exchange}" != "0.000" ] && [ -n "${exchange}" ] && echo "${exchange}"
			done | sort | head -n 1
		)
		echo "${buy}" "${sell}" >/tmp/check_exchange_rate
	fi
}

wm_status() {
	# Update RSS
	current_date="$(date +%s)"

	# shellcheck disable=SC2154
	next_update="$(($(stat -c %Y "${XDG_DATA_HOME}/newsboat/cache.db") + 1 * 60 * 60))"
	if [ "${current_date}" -ge "${next_update}" ]; then
		newsboat -x reload
	fi
	unset current_date next_update

	if ! systemctl -q is-active cronie; then
		echo "cronie unit is inactive"
		echo
	fi

	if grep -q '\[s2idle\]' /sys/power/mem_sleep; then
		cat /sys/power/mem_sleep
		echo
	fi

	check_imca
	check_exchange_rate
	status_news
	exchange_rate
}

print_hello() {
	if [ -z "${TMUX}" ]; then
		output_tmux=$(tmux list-sessions 2>/dev/null)
		if [ -n "${output_tmux}" ]; then
			echo "# tmux sessions"
			echo "${output_tmux}"
			echo
		fi
		unset output_tmux
	fi
}

exchange_rate() {
	read -r buy sell </tmp/check_exchange_rate

	echo "# cuantoestaeldolar.pe"
	{
		echo "buy: ${buy}"
		echo "sell: ${sell}"
	} | column

	unset response exchange
}
