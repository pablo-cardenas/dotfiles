source ~/.bash/env.bash

# Add local bin directories to PATH.
[ -d $HOME/.bin ] && PATH="$PATH:$HOME/.bin"
[ -d $HOME/.local/bin ] && PATH="$PATH:$HOME/.local/bin"
[ -d $HOME/.node_modules/bin ] && PATH="$PATH:$HOME/.node_modules/bin"
export npm_config_prefix=~/.node_modules

source ~/.bashrc

export PATH

unset try_source
