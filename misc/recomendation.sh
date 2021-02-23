#!/bin/sh

get_recomendation()
{
	. /root/srv/conf.conf

	num=0
	for i in ${server_list}; do
		num=$(( num + 1 ))
	done

	server_num=${num}

	if [ ${server_num} -eq 1 ]; then
		echo -n "${server_list}"
		exit 0
	fi

	num=1
	if [ -z "${current_srv}" ]; then
		for i in ${server_list}; do
			sysrc -qf /root/srv/conf.conf current_srv="${i}" > /dev/null 2>&1
			sysrc -qf /root/srv/conf.conf current_num="${num}" > /dev/null 2>&1
			echo "recomendation for $1: ${i}" >> /tmp/recomendation.log
			echo -n "${i}"
			exit 0
		done
	fi

	next_id=
	if [ ${current_num} -eq ${server_num} ]; then
		next_id=1
	else
		next_id=$(( current_num + 1 ))
	fi

	num=1
	for i in ${server_list}; do
		if [ ${num} -eq ${next_id} ]; then
			sysrc -qf /root/srv/conf.conf current_srv="${i}" > /dev/null 2>&1
			sysrc -qf /root/srv/conf.conf current_num="${num}" > /dev/null 2>&1
			echo "recomendation for $1: ${i}" >> /tmp/recomendation.log
			echo -n "${i}"
			exit 0
		fi
		num=$(( num + 1 ))
	done
	exit 0
}

if [ "${1}" = "lock" ]; then
	shift
	echo "wakeup for: [$*]" >> /tmp/recomendation.log
	get_recomendation
	exit 0
else
	# recursive execite via lockf wrapper
	lockf -s -t10 /tmp/recomendation.lock /usr/local/cbsd/modules/api.d/misc/recomendation.sh lock $*
fi

exit 0
