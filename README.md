# Hyphe Corpus Cleaner

Simple script and related Docker container to automatically remove old corpus from an Hyphe instance.


## Cleaner arguments
The following **required** arguments allow for the cleaning to take place:

- `HYPHE_API_URL`: Hyphe API URL to clean. For example, `http://HYPHE_HOST/HYPHE_PATH/api/`
- `HYPHE_MONGODB_HOST`: Mongo hostname.
- `HYPHE_MONGO_PORT`: Mongo hostname.
- `HYPHE_MONGO_DBNAME`: Mongo database name.
- `HYPHE_ADMIN_PASSWORD`: Admin password if set in backend config.

## Cleaner options
The following **optional** arguments allow to tweak the cleaning policy and loging:

- `CRON_SCHEDULE`: If defined, a built-in cron-like daemon will take care of running the the cleaning script at here-defined intervals.

This is mostly meant to be used with docker-compose and an always-running cleaning job.  
**Do not use this if you use another way of schedulling**, like Kubernetes cronjobs for instance (since it launches "one-shot" jobs at intervals defined in the kubernetes cronjob parameters) or if you simply run it manually from time to time.

A cron expression represents a set of times, using 6 space-separated fields.

Field name   | Mandatory? | Allowed values  | Allowed special characters
----------   | ---------- | --------------  | --------------------------
Seconds      | No         | 0-59            | * / , -
Minutes      | Yes        | 0-59            | * / , -
Hours        | Yes        | 0-23            | * / , -
Day of month | Yes        | 1-31            | * / , - ?
Month        | Yes        | 1-12 or JAN-DEC | * / , -
Day of week  | Yes        | 0-6 or SUN-SAT  | * / , - ?

For example, to clean every day at midnight sharp, set it to `0 0 0 * * *`

- `DAYSBACK`: Days to keep. **(Defaults to 7.)**
- `MAILER_HOST`: SMTP server hostname.
- `MAILER_PORT`: SMTP server port.
- `MAILER_FROM`: `From:` email address.
- `MAILER_TO`: `To:` email address(es). For example,  `name@provider.net,name2@provider.net`.  
If any of `MAILER_HOST`, `MAILER_PORT`, `MAILER_FROM` or `MAILER_TO` is missing, no mail will be sent and logging will only take place on the container's console.
- `MAIL_TIMEOUT`: Maximum amount of time (seconds) to wait for the mail to be sent. **(Defaults to 10 seconds.)**
- `MAIL_AND_CONSOLE`: When "MAIL_\*" variables are defined, the job's output are sent by mail; set this to `0` to prevent logs from being also displayed on the container's console. **(Defaults to 1.)**
- `NO_EMPTY_MAIL`: If set to "1" (default), prevents empty mail to be sent (if there is nothing to clean up and the job produces no output). **(Defaults to 1.)**


You also need to link this container to `mongo` and `backend` containers.

Sample for your `docker-compose.yml`:
```
services:
  cleaner:
    image: scpomedialab/hyphe-corpus-cleaner:latest
    links:
     - "mongo:mongo"
     - "backend:backend"
    environment:
     - CRON_SCHEDULE=0 30 04 * * *
     - HYPHE_MONGODB_HOST=mongo
     - HYPHE_API_URL=http://backend:6978/
     - HYPHE_MONGODB_PORT=27017
     - HYPHE_MONGODB_DBNAME=hyphe
```
