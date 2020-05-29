# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize histappend

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=2000

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

PATH="/home/pablo/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/pablo/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/pablo/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/pablo/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/pablo/perl5"; export PERL_MM_OPT;
