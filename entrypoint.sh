#!/bin/sh
SHELL="/bin/sh -c"
CMD="/usr/local/bin/python /clean_old_corpora.py ${DAYSBACK:-7}"
MAIL_TIMEOUT=${MAIL_TIMEOUT:-10}
MAIL_AND_CONSOLE=${MAIL_AND_CONSOLE:-1}
                                                                                                                     

if [ ! -z "$MAILER_HOST" ] && [ ! -z "$MAILER_PORT" ] && [ ! -z "$MAILER_FROM" ] && [ ! -z "$MAILER_TO" ]; then
        echo "Configuring mail from ${MAILER_FROM} via ${MAILER_HOST}:${MAILER_PORT}"
        echo "root:${MAILER_FROM}:${MAILER_HOST}:${MAILER_PORT}" > /etc/ssmtp/revaliases
        MAIL_COMMAND="| mail -s \"Mail from hyphe cleaner on ${HOSTNAME}\" ${MAILER_TO}"
	if [ -z "$CRON_SCHEDULE" ] ; then MAIL_COMMAND="$MAIL_COMMAND && sleep $MAIL_TIMEOUT" ; fi
	if [ "$MAIL_AND_CONSOLE" != "0" ] ; then
	        echo "Also logging to console since "MAIL_AND_CONSOLE" is not set to "0""
	        TEE="| tee /dev/stderr"
	fi
else
        echo "Mailer variables not defined, logging to console only..."
fi

if [ ! -z "$CRON_SCHEDULE" ] ; then GOCRON="go-cron "${CRON_SCHEDULE}" " ; fi

eval exec "${GOCRON}${SHELL} '${CMD} 2>&1 $TEE $MAIL_COMMAND'"
