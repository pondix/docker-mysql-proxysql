#!/bin/bash
. constants
printf "[$(date)] Waiting for ProxySQL service to initialize"
TIMEOUT=0
TIMEOUT_LIMIT=300
RC=1
while [ $RC -eq 1 ]
do
  if [ $TIMEOUT -gt $TIMEOUT_LIMIT ]
  then
    echo "[ERROR] Timeout of $TIMEOUT_LIMIT seconds reached while connecting to ProxySQL"
    exit 1
  fi
  sleep 1
  printf "."
  mysql -e"select 1;" -h127.0.0.1 -P6032 -uadmin -padmin  > /dev/null 2>&1
  RC=$?
  TIMEOUT=$((TIMEOUT+1))
done
printf "\n"

printf "[$(date)] Configuring ProxySQL...\n"

mysql -uadmin -padmin -h127.0.0.1 -P6032 < $(pwd)/conf/proxysql/config-local.sql
