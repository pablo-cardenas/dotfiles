# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize histappend

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=20000

# Bash completions
if ! shopt -oq posix; then
    [ -f /etc/bash_completion ] && source /etc/bash_completion
    [ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion
fi

LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

source ~/.bash/aliases.bash

for f in ~/.bash/local.d/*.bash; do
    if [ -x $f ]; then source $f; fi
done

# Para clases
#export PS1='\[\033[01;31m\]\W $\[\033[00m\] '

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export PYTHONSTARTUP=${HOME}/.pythonrc.py
