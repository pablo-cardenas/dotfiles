#!/bin/bash

winid=$(xdotool search --class Emacs)
visible_winid=$(xdotool search --onlyvisible --class Emacs)

echo $winid
echo $visible_winid
if [ -z "$winid" ]; then
	nohup emacs >/dev/null 2>/dev/null </dev/null &
else
	if [ -z "$visible_winid" ]; then
		echo "$winid" | tac | xargs -I{} xdo show {}
	else
		echo "$winid" | xargs -I{} xdo hide {}
	fi
fi
