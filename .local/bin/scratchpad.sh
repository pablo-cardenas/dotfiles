#!/bin/sh

winid=$(xdotool search --class Emacs)
visible_winid=$(xdotool search --onlyvisible --class Emacs)


if [ -z "${winid}" ]; then
	nohup emacs >/dev/null 2>/dev/null </dev/null &
else
	for id in ${winid}; do
		if ! xprop -id "${id}" _NET_WM_OPAQUE_REGION |
			grep -q "not found"; then
			echo "${id}"
		fi
	done |
		if [ -z "${visible_winid}" ]; then
			tac | xargs -I{} xdo show {}
		else
			xargs -I{} xdo hide {}
		fi
fi
