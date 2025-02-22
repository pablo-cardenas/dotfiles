#!/bin/sh

create_session() {
	group=$1
	session=$2
	path=$3
	mkdir -p "${path}"

	if ! tmux list-sessions -F '#{session_group}' | grep -q impa; then
		tmux new-session -s "${session}" -t "${group}" -d -c "${path}"
		tmux new-window -t "${session}": -n "${session}" -c "${path}"
		tmux kill-window -t "${session}":0
	fi

	if ! tmux has-session -t "${session}" 2>/dev/null; then
		tmux new-session -s "${session}" -t "${group}" -d -c "${path}"
	fi

	if ! tmux list-windows -t "${session}" -F '#{window_name}' | grep -q "${session}"; then
		tmux new-window -t "${session}": -n "${session}" -c "${path}"
	elif { tmux display-message -p '#{window_name}' | grep -q "${session}"; } && ! [ "$PWD" -ef "${path}" ]; then
		pushd "${path}" >/dev/null || return
		dirs -v
	fi

	if [ -z "${TMUX}" ]; then
		tmux attach -t "${session}"
	fi

	tmux switch-client -t "${session}"
	tmux select-window -t "${session}:${session}"
	unset group session path
}

fa() {
	create_session impa fa ~/dox/dev/notes-functional-analysis
}

hdp() {
	create_session impa hdp ~/dox/dev/notes-high-dimension-probability
}

mt() {
	create_session impa mt ~/dox/dev/notes-measure-theory
}
