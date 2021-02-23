#!/bin/sh

get_recomendation()
{
	. /root/srv/conf.conf

	if [ -z "${next_uid}" ]; then
		sysrc -qf /root/srv/conf.conf next_uid="1" > /dev/null 2>&1
		echo -n "1"
	fi

	next_uid=$(( next_uid + 1 ))
	sysrc -qf /root/srv/conf.conf next_uid="${next_uid}" > /dev/null 2>&1
	echo -n "${next_uid}"
	exit 0
}

if [ "${1}" = "lock" ]; then
	shift
	echo "wakeup for: [$*]" >> /tmp/freejname.log
	get_recomendation
	exit 0
else
	# recursive execite via lockf wrapper
	lockf -s -t10 /tmp/recomendation.lock /usr/local/cbsd/modules/api.d/misc/freejname.sh lock $*
fi

exit 0
