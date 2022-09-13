#!/bin/bash

while [ $(pgrep '^newsboat$') ]
do
	sleep 1s
done

if [[ ( -n $(find $XDG_CONFIG_HOME/newsboat/cache.db -mmin +5) ) ||  ( $XDG_CONFIG_HOME/newsboat/cache.db -ot $XDG_CONFIG_HOME/newsboat/urls ) ]]
then
	newsboat -x reload > /dev/null
fi

newsboat -x print-unread | awk '{ print " " $1 }'
