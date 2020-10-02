#!/bin/bash
. constants
#set -x

printf "$YELLOW[$(date)] Waiting for MariaDB service on master"
# INIT REPL ONCE SLAVE IS UP
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysqladmin ping -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD  > /dev/null 2>&1
  RC=$?
done
printf "$LIME_YELLOW\n"

printf "$POWDER_BLUE[$(date)] Configuring slave 1...$LIME_YELLOW\n"
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"SET GLOBAL READ_ONLY=0;" > /dev/null 2>&1

printf "$YELLOW[$(date)] Waiting for MariaDB service on slave 1"
# INIT REPL ONCE SLAVE IS UP
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysqladmin ping -h127.0.0.1 -P13307 -uroot -p$MYSQL_PWD > /dev/null 2>&1
  RC=$?
done
printf "$LIME_YELLOW\n"


BLF=$(mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"SHOW MASTER STATUS\G" | grep File | awk '{print $2}')
BLP=$(mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"SHOW MASTER STATUS\G" | grep Position | awk '{print $2}')
BLG=$(mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -NB -e"SELECT BINLOG_GTID_POS('$BLF', $BLP)")

printf "$POWDER_BLUE[$(date)] Configuring slave 1...$LIME_YELLOW\n"
mysql -h127.0.0.1 -P13307 -uroot -p$MYSQL_PWD -e"SET GLOBAL gtid_slave_pos = '$BLG'; CHANGE MASTER TO MASTER_HOST='mysql1',MASTER_USER='root',MASTER_PASSWORD='$MYSQL_PWD',MASTER_USE_GTID=slave_pos;" -vvv
mysql -h127.0.0.1 -P13307 -uroot -p$MYSQL_PWD -e"START SLAVE; SET GLOBAL READ_ONLY=1;" > /dev/null 2>&1 

printf "$YELLOW[$(date)] Waiting for MariaDB service on slave 2"
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysqladmin ping -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD > /dev/null 2>&1
  RC=$?
done
printf "$LIME_YELLOW\n"

printf "$POWDER_BLUE[$(date)] Configuring slave 2...$LIME_YELLOW\n"
mysql -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD -e"SET GLOBAL gtid_slave_pos = '$BLG'; CHANGE MASTER TO MASTER_HOST='mysql1',MASTER_USER='root',MASTER_PASSWORD='$MYSQL_PWD',MASTER_USE_GTID=slave_pos;" -vvv
mysql -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD -e"START SLAVE; SET GLOBAL READ_ONLY=1;" > /dev/null 2>&1 

printf "$POWDER_BLUE[$(date)] Create additional database(s) on master...['sysbench']$LIME_YELLOW\n"
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"GRANT usage,replication client on *.* to monitor@'%' identified by 'monitor';" > /dev/null 2>&1 
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"CREATE DATABASE sysbench" > /dev/null 2>&1 

printf "$POWDER_BLUE$BRIGHT[$(date)] MariaDB Provisioning COMPLETE!$NORMAL\n"

