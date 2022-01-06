#!/bin/bash

while [ $(pgrep '^newsboat$') ]
do
	sleep 1s
done

if [[ ( -n $(find ~/.newsboat/cache.db -mmin +5) ) ||  ( ~/.newsboat/cache.db -ot ~/.newsboat/urls ) ]]
then
	newsboat -x reload > /dev/null
fi

newsboat -x print-unread | awk '{ print " " $1 }'
