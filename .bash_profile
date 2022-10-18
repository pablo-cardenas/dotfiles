export EDITOR=vim
export PAGER=less
export LANG=en_US.UTF-8
export BROWSER=elinks

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Add local bin directories to PATH.
[ -d $HOME/.local/bin ] && PATH="$PATH:$HOME/.local/bin"
[ -d $XDG_DATA_HOME/npm/bin ] && PATH="$PATH:$XDG_DATA_HOME/npm/bin/"
[ -d /usr/local/texlive/2022/bin/x86_64-linux ] && PATH="$PATH:/usr/local/texlive/2022/bin/x86_64-linux"
[ -d $XDG_DATA_HOME/gem/ruby/3.0.0/bin/ ] && PATH="$PATH:$XDG_DATA_HOME/gem/ruby/3.0.0/bin/"
[ -d $HOME/perl5/bin ] && PATH="$PATH:/home/pablo/perl5/bin}"

#export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
export MAXIMA_USERDIR="$XDG_CONFIG_HOME"/maxima
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonstartup.py
export RANDFILE="$XDG_RUNTIME_DIR"/rnd
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

export BIB="$XDG_CONFIG_HOME/bib/references.bib"
export BIB_DATA="$XDG_DATA_HOME/bib"

export PERL5LIB="$HOME/perl5/lib/perl5"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

source ~/.bashrc

export PATH

unset try_source
