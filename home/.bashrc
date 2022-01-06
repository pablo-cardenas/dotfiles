# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize histappend histreedit

HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000
HISTTIMEFORMAT="%d/%m/%y %T "

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

LESS=-R
LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
LESS_TERMCAP_ue=$'\E[0m'        # reset underline

PYTHONSTARTUP=${HOME}/.pythonrc.py


source /usr/share/git/completion/git-prompt.sh
#export GIT_PS1_SHOWCOLORHINTS=1
#export GIT_PS1_SHOWDIRTYSTATE=1
PS1='[\u@\h \W]$(__git_ps1) \$ '
