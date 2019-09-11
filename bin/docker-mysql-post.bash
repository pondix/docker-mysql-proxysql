#!/bin/bash
. constants

printf "[$(date)] Waiting for MySQL service on master"
# INIT REPL ONCE SLAVE IS UP
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysql -e"select 1;" -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD  > /dev/null 2>&1
  RC=$?
done
printf "\n"

printf "[$(date)] Configuring slave 1...\n"
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"SET GLOBAL READ_ONLY=0;" > /dev/null 2>&1

printf "[$(date)] Waiting for MySQL service on slave 1"
# INIT REPL ONCE SLAVE IS UP
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysql -e"select 1;" -h127.0.0.1 -P13307 -uroot -p$MYSQL_PWD > /dev/null 2>&1
  RC=$?
done
printf "\n"

printf "[$(date)] Configuring slave 1...\n"
mysql -h127.0.0.1 -P13307 -uroot -p$MYSQL_PWD -e"CHANGE MASTER TO MASTER_HOST='mysql1',MASTER_USER='root',MASTER_PASSWORD='$MYSQL_PWD',MASTER_AUTO_POSITION = 1;" > /dev/null 2>&1 
mysql -h127.0.0.1 -P13307 -uroot -p$MYSQL_PWD -e"START SLAVE; SET GLOBAL READ_ONLY=1;" > /dev/null 2>&1 

printf "[$(date)] Waiting for MySQL service on slave 2"
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysql -e"select 1;" -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD > /dev/null 2>&1
  RC=$?
done
printf "\n"

printf "[$(date)] Configuring slave 2...\n"
mysql -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD -e"CHANGE MASTER TO MASTER_HOST='mysql2',MASTER_USER='root',MASTER_PASSWORD='$MYSQL_PWD',MASTER_AUTO_POSITION = 1;" > /dev/null 2>&1 
mysql -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD -e"START SLAVE; SET GLOBAL READ_ONLY=1;" > /dev/null 2>&1 

printf "[$(date)] Create additional database(s) on master...['sysbench']\n"
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"GRANT usage,replication client on *.* to monitor@'%' identified by 'monitor';" > /dev/null 2>&1
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"GRANT all on *.* to user@'%' identified by 'user';" > /dev/null 2>&1
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"CREATE DATABASE sysbench" > /dev/null 2>&1 

printf "[$(date)] MySQL Provisioning COMPLETE!\n"

