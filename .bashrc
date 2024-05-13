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

[ -f /usr/share/git/completion/git-prompt.sh ] && source /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWCOLORHINTS=
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_COMPRESSSPARSESTATE=1
GIT_PS1_SHOWCONFLICTSTATE=1
GIT_PS1_HIDE_IF_PWD_IGNORED=1
PS1='\$$([[ $PWD/ = $HOME/* ]] && GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME __git_ps1)$(__git_ps1) '

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
	if [ $1 = "--git-dir" ]; then
		local git_args="$git_args $1 $2"
		shift 2
	fi
	if [ $1 = "--work-tree" ]; then
		local git_args="$git_args $1 $2"
		shift 2
	fi

	if [ $1 = "checkout" ]; then
		echo "Use"
		echo " - git checkout-index -fu"
		echo " - git read-tree --cached -u"
	elif [ $1 = "reset" ]; then
		echo "Use"
		echo " - git read-tree -mu"
		echo " - git read-tree -m"
		echo " - git update-index --add --remove --cacheinfo 100644 sha1 filename"
	elif [ $1 = "status" -a $# = 1 ]; then
		echo "Use"
		echo " - git diff-files --name-only"
		echo " - git diff-index --name-only HEAD"
		echo " - git ls-files -mot"
		echo " - git status -bs"
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
	'{ [ -z "$TMUX" ] && [[ $TERM != tmux-* ]] && [ "$ASCIINEMA_REC" != 1 ] && [ -n "$DISPLAY" -o -n "$TERMUX_VERSION" ]; } && { [ -z "$FIRST_COMMAND" ] && FIRST_COMMAND=1 || exit; }'
)
