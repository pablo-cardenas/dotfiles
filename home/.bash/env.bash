export EDITOR=nvim
export PAGER=less
export LANG=es_ES.UTF-8
export BROWSER=qutebrowser

# /usr/bin/open will be present on macOS
if [ -x /usr/bin/open ]; then
  export BROWSER=open
fi
