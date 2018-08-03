# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize histappend

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=2000


# TODO: What's a portable way for doing this?
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Bash completions
if ! shopt -oq posix; then
    [ -f /etc/bash_completion ] && source /etc/bash_completion
    [ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion
fi

source ~/.bash/colors.bash
source ~/.bash/aliases.bash
source ~/.bash/functions.bash
source ~/.bash/prompt.bash

for f in ~/.bash/local.d/*.bash; do
    if [ -x $f ]; then . $f; fi
done

export EDITOR=nvim

# Para clases
#export PS1='\[\033[01;31m\]\W $\[\033[00m\] '

# Base16 Shell
BASE16_SHELL_SET_BACKGROUND=false    
BASE16_SHELL="$HOME/.base16-manager/chriskempson/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
