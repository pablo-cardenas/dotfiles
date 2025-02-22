# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -n "${DISPLAY}" ]] && shopt -s checkwinsize

shopt -s histappend histreedit
mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}"/bash
HISTFILE="${XDG_STATE_HOME:-${HOME}/.local/state}"/bash/history
HISTCONTROL=ignoreboth
HISTSIZE=200000
HISTFILESIZE=400000
HISTTIMEFORMAT="%D %T "

# shellcheck disable=SC2034
GPG_TTY=$(tty)

PS1='\$ '


# shellcheck source=.config/shell/alias.sh
source "${XDG_CONFIG_HOME:-${HOME}/.config}"/shell/alias.sh

# shellcheck source=.config/shell/functions.sh
source "${XDG_CONFIG_HOME:-${HOME}/.config}"/shell/functions.sh

# shellcheck source=.config/shell/sessions.sh
source "${XDG_CONFIG_HOME:-${HOME}/.config}"/shell/sessions.sh

## shellcheck source=.config/shell/hardmode.sh
#source "${XDG_CONFIG_HOME:-${HOME}/.config}"/shell/hardmode.sh

trap print_goodbye EXIT
print_hello
