# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History operations: modify the way command history is stored.
HISTCONTROL=ignoreboth      # don't put duplicate lines on history
shopt -s histappend         # append to history instead of overwriting
HISTSIZE=1000               # max number of commands to save in history
HISTFILESIZE=2000           # max number of lines in history file

# Re-evaluate window size after each command. Useful on X terminals
shopt -s checkwinsize

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Enable colors if the program is available
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Para clases
#export PS1='\[\033[01;31m\]$\[\033[00m\] '
