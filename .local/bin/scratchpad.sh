#!/bin/bash

winid=$(xdotool search --class Emacs | head -n 1)
visible_winid=$(xdotool search --onlyvisible --class Emacs)

echo $winid
echo $visible_winid
if [ -z "$winid" ]; then
	nohup emacs >/dev/null 2>/dev/null </dev/null &
else
	if [ -z "$visible_winid" ]; then
		xdo show "$winid"
	else
		xdo hide "$visible_winid"
	fi
fi
