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

alias ls='ls -AF'
alias vim='vim -u ~/.vim/vimrc'
alias dotfiles='git --git-dir "$HOME"/.dotfiles --work-tree "$HOME"'

cd() { echo "Use pushd!"; }

man() {
	if [[ $1 == -* || $1 == [1-9]* || $1 == n ]] ; then
		command man "$@"
	else
		echo "Specify section"
		return 1
	fi
}

git() {
	if [ "$1" = "--git-dir" ]; then
		local git_args+=("$1" "$2")
		shift 2
	fi
	if [ "$1" = "--work-tree" ]; then
		local git_args+=("$1" "$2")
		shift 2
	fi

	if [ "$1" = "checkout" ]; then
		echo "Use"
		echo " - git checkout-index -fu"
		echo " - git read-tree --cached -u"
	elif [ "$1" = "reset" ]; then
		echo "Use"
		echo " - git read-tree -mu"
		echo " - git read-tree -m"
		echo " - git update-index --add --remove --cacheinfo 100644 sha1 filename"
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
		command git "${git_args[@]}" "$@"
	fi
}

# shellcheck disable=SC2016
PROMPT_COMMAND+=(
	'{ [ -z "$TMUX" ] && [[ $TERM != tmux-* ]] && [ "$ASCIINEMA_REC" != 1 ] && [ -n "$DISPLAY" -o -n "$TERMUX_VERSION" -o -n "$MSYSTEM" ]; } && { [ -z "$FIRST_COMMAND" ] && FIRST_COMMAND=1 || exit; }'
)

print_goodbye() {
	# shellcheck disable=SC2016
	if [ -z "${TMUX}" ] && { [ -n "$(dotfiles ls-files --others --exclude-standard --directory --no-empty-directory || true)" ] || ! dotfiles submodule foreach '[ -z "$(git ls-files --modified --others --exclude-standard --directory --no-empty-directory)" ]'>/dev/null 2>/dev/null; }; then
		echo "In dotfiles:"
		dotfiles status -s
		dotfiles submodule foreach 'git status -s'
		read -rn 1
	fi
}
trap print_goodbye EXIT
