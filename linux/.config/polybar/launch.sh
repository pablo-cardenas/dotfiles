#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch top and bottom
MONITOR=HDMI-0 polybar top &
MONITOR=HDMI-0 polybar bottom &

MONITOR=VGA1 polybar top &
MONITOR=VGA1 polybar bottom &



echo "Bars launched..."
