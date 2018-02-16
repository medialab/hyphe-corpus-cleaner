#!/bin/sh
exec go-cron "${CRON_SCHEDULE}" /bin/sh -c "python /clean_old_corpora.py ${DAYSBACK}"
