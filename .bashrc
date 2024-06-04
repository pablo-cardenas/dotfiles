# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -n "${DISPLAY}" ]] && shopt -s checkwinsize

shopt -s histappend histreedit
mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}"/bash
HISTFILE="${XDG_STATE_HOME:-${HOME}/.local/state}"/bash/history
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000
HISTTIMEFORMAT="%D %T "

LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

# shellcheck disable=SC2034
GPG_TTY=$(tty)

PS1='\$ '

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

# shellcheck source=.config/shell/alias.sh
source "${XDG_CONFIG_HOME:-${HOME}/.config}"/shell/alias.sh
# shellcheck source=.config/shell/functions.sh
source "${XDG_CONFIG_HOME:-${HOME}/.config}"/shell/functions.sh

trap print_goodbye EXIT
