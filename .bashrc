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
#export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_COMPRESSSPARSESTATE=1
export GIT_PS1_SHOWCONFLICTSTATE=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
PS1='\$$(GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME __git_ps1)$(__git_ps1) '

cd() { echo "Use pushd!"; }

man() {
	if [[ $1 == -* || $1 == [1-9]* || $1 == n ]] ; then
		command man $@
	else
		echo "Specify section"
		return 1
	fi
}


[ -f /usr/share/bash-completion/completions/git ] && source /usr/share/bash-completion/completions/git
[ -f /data/data/com.termux/files/usr/share/bash-completion/completions/git ] && source /dataa/data/com.termux/files/usr/share/bash-completion/completions/git
__git_complete config __git_main

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

PROMPT_COMMAND+=('FIRST_COMMAND=$((FIRST_COMMAND+1))' '[ -n "$DISPLAY" -a -z "$TMUX" -a "$FIRST_COMMAND" -gt 1 ] && exit')
