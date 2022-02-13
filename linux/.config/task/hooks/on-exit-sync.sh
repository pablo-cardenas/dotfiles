#!/bin/sh

n=0
while read modified_task
do
  n=$(($n + 1))
done

if (($n > 0)); then
    echo "on-exit: Counted $n added/modified tasks."
    task sync
fi

exit 0
