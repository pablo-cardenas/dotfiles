active_id=$(task +ACTIVE rc.verbose: limit:1 id | cut -d ' ' -f1)
next_id=$(task next rc.verbose: limit:1 id | cut -d ' ' -f1)

if [ -z $active_id ]
then
	echo NEXT $(task _get ${next_id}.description)
else
	echo ACTIVE $(task _get ${active_id}.description)
fi
