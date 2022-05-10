export EDITOR=vim
export PAGER=less
export LANG=en_US.UTF-8
export BROWSER=elinks

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Add local bin directories to PATH.
[ -d $HOME/.bin ] && PATH="$PATH:$HOME/.bin"
[ -d $HOME/.local/bin ] && PATH="$PATH:$HOME/.local/bin"
[ -d $XDG_DATA_HOME/npm/bin ] && PATH="$PATH:$XDG_DATA_HOME/npm/bin/"

#export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
export MAXIMA_USERDIR="$XDG_CONFIG_HOME"/maxima
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/pythonstartup.py
export RANDFILE="$XDG_RUNTIME_DIR"/rnd
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

source ~/.bashrc

export PATH

unset try_source
