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
#command -v picom >/dev/null 2>&1 && picom --experimental-backends --backend glx &
#command -v picom >/dev/null 2>&1 && picom -bc
udiskie &
dunst &
redshift &
xset -b &
xsetwacom set 16 MapToOutput HDMI1
xsetwacom set 17 MapToOutput HDMI1
#hsetroot -solid gray50
xrandr \
    --output HDMI1 --mode 1920x1080 \
    --output VGA1 --mode 1440x900 \
    --right-of HDMI1
command -v feh >/dev/null 2>&1 && feh --bg-scale $HOME/.wallpaper


session=${1:-i3}
case $session in
    i3|i3wm           ) exec i3;;
    openbox           ) exec openbox-session;;
    *                 ) exec $1;;
esac
