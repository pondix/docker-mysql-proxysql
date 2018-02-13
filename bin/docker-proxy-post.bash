#!/bin/bash
. constants
printf "$YELLOW[$(date)] Waiting for ProxySQL service to initialize"
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysqladmin ping -h127.0.0.1 -P16032 -uradmin -pradmin  > /dev/null 2>&1
  RC=$?
done
printf "$LIME_YELLOW\n"

printf "$POWDER_BLUE[$(date)] Configuring ProxySQL...$LIME_YELLOW\n"

mysql -uradmin -pradmin -h127.0.0.1 -P16032 < $(pwd)/conf/proxysql/config.sql
