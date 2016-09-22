#!/bin/sh

apm=/usr/bin/apm-plane-disco
rw_apm=/data/ftp/internal_000/APM/apm-plane-disco

if [ -f "${rw_apm}" ]; then
	chmod +x ${rw_apm}
	apm=${rw_apm}
fi

exec ${apm} $@
