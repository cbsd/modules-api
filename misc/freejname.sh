#!/bin/sh
: ${distdir="/usr/local/cbsd"}

# MAIN
if [ -z "${workdir}" ]; then
	[ -z "${cbsd_workdir}" ] && . /etc/rc.conf
	[ -z "${cbsd_workdir}" ] && exit 0
	workdir="${cbsd_workdir}"
fi

[ ! -f "${distdir}/cbsd.conf" ] && exit 1

get_recomendation()
{
	local _conf="${workdir}/etc/api.conf"

	. ${_conf}

	if [ -z "${next_uid}" ]; then
		sysrc -qf ${_conf} next_uid="1" > /dev/null 2>&1
		echo -n "1"
		exit 0
	fi

	next_uid=$(( next_uid + 1 ))
	sysrc -qf ${_conf} next_uid="${next_uid}" > /dev/null 2>&1
	echo -n "${next_uid}"
	exit 0
}

if [ "${1}" = "lock" ]; then
	shift
	get_recomendation
	exit 0
else
	# recursive execite via lockf wrapper
	lockf -s -t10 /tmp/recomendation.lock /usr/local/cbsd/modules/api.d/misc/freejname.sh lock $*
fi

exit 0
