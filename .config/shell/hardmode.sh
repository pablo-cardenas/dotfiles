# shellcheck shell=sh

cd() {
	echo "Use pushd!"
	return 1
}

pwd() {
	echo "Use dirs [-v]"
	return 1
}

man() {
	case $1 in
	-* | [0-9]* | n)
		command man "$@"
		;;
	*)
		echo "Specify section"
		return 1
		;;
	esac
}

git() {
	if [ "$1" = "--git-dir" ]; then
		_git_dir="$2"
		shift 2
	fi
	if [ "$1" = "--work-tree" ]; then
		_work_tree="$2"
		shift 2
	fi
	if [ "$1" = "-C" ]; then
		_c="$2"
		shift 2
	fi

	if [ "$1" = "checkout" ]; then
		echo "Use"
		echo " - git checkout-index -fu"
		echo " - git read-tree --reset -u"
	elif [ "$1" = "reset" ]; then
		echo "Use"
		echo " - git read-tree -mu"
		echo " - git read-tree -m"
		echo " - git update-index --add --remove \
--cacheinfo 100644 sha1 filename"
	elif [ "$1" = "status" ] && [ $# = 1 ]; then
		echo "Use"
		echo " - git diff-index --cached HEAD"
		echo " - git diff-files"
		echo " - git ls-files --exclude-standard -o"
		echo " - git status -bs"
	elif [ "$1" = "log" ]; then
		echo "Use"
		echo " - git rev-list HEAD"
	else
		if [ -n "${_git_dir}" ]; then
			set -- --git-dir "${_git_dir}" "$@"
		fi
		if [ -n "${_work_tree}" ]; then
			set -- --work-tree "${_work_tree}" "$@"
		fi
		if [ -n "${_c}" ]; then
			set -- -C "${_c}" "$@"
		fi
		unset _git_dir _work_tree _c
		command git "$@"
		return $?
	fi
	return 1
}

tmux() {
	if [ $# = 0 ]; then
		echo "Don't use tmux without arguments"
		return 1
	fi

	if [ "$1" = "new-session" ] || [ "$1" = "new" ] && [ "$2" != "-c" ]; then
		echo "Specify the working directory."
		return 1
	fi

	command tmux "$@"
}

# shellcheck disable=SC2016
PROMPT_COMMAND+=(
	'{
		[[ -z "$TMUX" ]] &&
		[[ $TERM != tmux-* ]] &&
		[[ "$ASCIINEMA_REC" != 1 ]] && {
			[[ -n "$DISPLAY" ]] ||
			[[ -n "$TERMUX_VERSION" ]] ||
			[[ -n "$MSYSTEM" ]]
		}
	} && {
		[[ -z "$FIRST_COMMAND" ]] &&
		FIRST_COMMAND=1 || exit;
	}'
)
