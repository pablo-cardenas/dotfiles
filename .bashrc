# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

# Bash completions
if ! shopt -oq posix; then
	[ -f /etc/bash_completion ] && source /etc/bash_completion
	[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion
fi

shopt -s histappend histreedit
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}"/bash
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}"/bash/history
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000
HISTTIMEFORMAT="%D %T "

LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

source "${XDG_CONFIG_HOME:-$HOME/.config}"/shell/aliases.sh

GPG_TTY=$(tty)

PS1='\$ '

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
		local git_args="$git_args $1 $2"
		shift 2
	fi
	if [ "$1" = "--work-tree" ]; then
		local git_args="$git_args $1 $2"
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
	elif [ "$1" = "status" -a $# = 1 ]; then
		echo "Use"
		echo " - git diff-index --cached HEAD"
		echo " - git diff-files"
		echo " - git ls-files --exclude-standard -o"
		echo " - git status -bs"
	elif [ "$1" = "log" ]; then
		echo "Use"
		echo " - git rev-list HEAD"
	else
		command git $git_args "$@"
	fi
}

[ -f /usr/share/bash-completion/completions/git ] && source /usr/share/bash-completion/completions/git
[ -f /data/data/com.termux/files/usr/share/bash-completion/completions/git ] && source /dataa/data/com.termux/files/usr/share/bash-completion/completions/git
__git_complete dotfiles __git_main

countdown() {
	start="$(($(date '+%s') + $1))"
	while [ $start -ge $(date +%s) ]; do
		time="$(($start - $(date +%s)))"
		printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
		sleep 0.1
	done
}

stopwatch() {
	start=$(date +%s)
	while true; do
		time="$(($(date +%s) - $start))"
		printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
		sleep 0.1
	done
}

PROMPT_COMMAND+=(
	'{ [ -z "$TMUX" ] && [[ $TERM != tmux-* ]] && [ "$ASCIINEMA_REC" != 1 ] && [ -n "$DISPLAY" -o -n "$TERMUX_VERSION" -o -n "$MSYSTEM" ]; } && { [ -z "$FIRST_COMMAND" ] && FIRST_COMMAND=1 || exit; }'
)

print_goodbye() {
	if [ -z "$TMUX" ] && { [ ! -z "$(dotfiles ls-files --others --exclude-standard --directory --no-empty-directory )" ] || ! dotfiles submodule foreach '[ -z "$(git ls-files --others --exclude-standard --directory --no-empty-directory)" ]'; }; then
		dotfiles status -s
		dotfiles submodule foreach 'git status -s'
		read -n 1
	fi
}
trap print_goodbye EXIT
