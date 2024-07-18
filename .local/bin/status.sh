#!/bin/sh

winid=$(xdotool search --name watch)
visible_winid=$(xdotool search --onlyvisible --name watch)


if [ -z "${winid}" ]; then
	nohup st -t watch -e  bash -c 'while true; do watch --interval 60 --chgexit ". ~/.config/shell/functions.sh; wm_status"; notify-send "Status changed"; done' >/dev/null 2>/dev/null </dev/null &
else
	if [ -z "${visible_winid}" ]; then
		xdo show "${winid}"
	else 
		xdo hide "${winid}"
	fi
fi
