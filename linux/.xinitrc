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

setxkbmap -layout us -variant altgr_intl
xset r rate 250 40
[[ -d /usr/share/fonts/terminus ]] && xset +fp /usr/share/fonts/terminus
udiskie &
dunst &
redshift &
xset -b &
xset s 600 60
xss-lock -- i3lock -n -i /usr/share/backgrounds/archlinux/geolanes.png &


xrandr \
    --output VGA1 --auto \
    --output HDMI-0 --auto \
    --right-of VGA1
command -v picom >/dev/null 2>&1 && picom --experimental-backends -b
command -v feh >/dev/null 2>&1 && feh --bg-scale /usr/share/backgrounds/archlinux/reflected.jpg


session=${1:-i3}
case $session in
    i3|i3wm           ) exec i3;;
    openbox           ) exec openbox-session;;
    *                 ) exec $1;;
esac
