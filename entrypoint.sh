#!/bin/sh
if [ ! -z "$MAILER_HOST" ] && [ ! -z "$MAILER_PORT" ] && [ ! -z "$MAILER_FROM" ] && [ ! -z "$MAILER_TO" ]; then
	echo "root:${MAILER_FROM}:${MAILER_HOST}:${MAILER_PORT}" > /etc/ssmtp/revaliases
	exec go-cron "${CRON_SCHEDULE}" /bin/sh -c "/usr/local/bin/python /clean_old_corpora.py ${DAYSBACK} | mail -s 'cron ${HOSTNAME}' ${MAILER_TO}"
else
	echo "Mailer variables not defined, logging to stdout..."
	exec go-cron "${CRON_SCHEDULE}" /bin/sh -c "python /clean_old_corpora.py ${DAYSBACK}"
fi
