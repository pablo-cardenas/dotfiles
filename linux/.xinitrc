#!/bin/sh

# merge in defaults and keymaps
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap
[[ -f $sysresources ]]  && xrdb -merge $sysresources
[[ -f $sysmodmap ]]     && xmodmap $sysmodmap
[[ -f $userresources ]] && xrdb -merge "$userresources"
[[ -f $usermodmap ]]    && xmodmap "$usermodmap"

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?* ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap -model pc104 -layout us,es  -option grp:ctrls_toggle
[[ -d /usr/share/fonts/terminus ]] && xset +fp /usr/share/fonts/terminus
command -v picom >/dev/null 2>&1 && picom -bc &
#command -v feh >/dev/null 2>&1 && feh --bg-scale $HOME/.wallpaper
udiskie &
dunst &
redshift &
xset -b
hsetroot -solid gray50


session=${1:-i3}
case $session in
    i3|i3wm           ) exec i3;;
    openbox           ) exec openbox-session;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac
