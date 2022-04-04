#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
#polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
export PRIMARY_MONITOR=PRIMARY
export SECONDARY_MONITOR=SECONDARY
polybar primary-top 2>&1 | tee -a /tmp/polybar-primary-top.log & disown
polybar primary-bottom 2>&1 | tee -a /tmp/polybar-primary-bottom.log & disown
polybar secondary-top 2>&1 | tee -a /tmp/polybar-primary-top.log & disown
polybar secondary-bottom 2>&1 | tee -a /tmp/polybar-primary-bottom.log & disown

echo "Bars launched..."
