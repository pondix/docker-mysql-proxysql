#!/bin/bash
. constants

printf "$YELLOW[$(date)] Waiting for MySQL service on master"
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

mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e" \
SET SQL_LOG_BIN=0; \
CREATE USER rpl_user@'%' IDENTIFIED BY 'password'; \
GRANT REPLICATION SLAVE ON *.* TO rpl_user@'%'; \
FLUSH PRIVILEGES; \
SET SQL_LOG_BIN=1; \
CHANGE MASTER TO MASTER_USER='rpl_user', MASTER_PASSWORD='password' FOR CHANNEL 'group_replication_recovery'; \
SET GLOBAL group_replication_bootstrap_group=ON; \
SET GLOBAL group_replication_allow_local_disjoint_gtids_join=ON; \
START GROUP_REPLICATION; \
SET GLOBAL group_replication_allow_local_disjoint_gtids_join=OFF; \
SET GLOBAL group_replication_bootstrap_group=OFF; \
SELECT * FROM performance_schema.replication_group_members;"

printf "$YELLOW[$(date)] Waiting for MySQL service on slave 1"
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

mysql -h127.0.0.1 -P13307 -uroot -p$MYSQL_PWD -e" \
SET SQL_LOG_BIN=0; \
CREATE USER rpl_user@'%' IDENTIFIED BY 'password'; \
GRANT REPLICATION SLAVE ON *.* TO rpl_user@'%'; \
FLUSH PRIVILEGES; \
SET SQL_LOG_BIN=1; \
CHANGE MASTER TO MASTER_USER='rpl_user', MASTER_PASSWORD='password' FOR CHANNEL 'group_replication_recovery'; \
SET GLOBAL group_replication_allow_local_disjoint_gtids_join=ON; \
START GROUP_REPLICATION; \
SET GLOBAL group_replication_allow_local_disjoint_gtids_join=OFF; \
SELECT * FROM performance_schema.replication_group_members;"

printf "$YELLOW[$(date)] Waiting for MySQL service on slave 2"
RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  mysqladmin ping -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD > /dev/null 2>&1
  RC=$?
done
printf "$LIME_YELLOW\n"

mysql -h127.0.0.1 -P13308 -uroot -p$MYSQL_PWD -e" \
SET SQL_LOG_BIN=0; \
CREATE USER rpl_user@'%' IDENTIFIED BY 'password'; \
GRANT REPLICATION SLAVE ON *.* TO rpl_user@'%'; \
FLUSH PRIVILEGES; \
SET SQL_LOG_BIN=1; \
CHANGE MASTER TO MASTER_USER='rpl_user', MASTER_PASSWORD='password' FOR CHANNEL 'group_replication_recovery'; \
SET GLOBAL group_replication_allow_local_disjoint_gtids_join=ON; \
START GROUP_REPLICATION; \
SET GLOBAL group_replication_allow_local_disjoint_gtids_join=OFF; \
SELECT * FROM performance_schema.replication_group_members;"

printf "$YELLOW[$(date)] Adding ProxySQL cluster state monitor script and user:"
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD < ./conf/mysql/addition_to_sys.sql 2>&1
mysql -h127.0.0.1 -P13306 -uroot -p$MYSQL_PWD -e"GRANT usage,replication client on *.* to monitor@'%' identified by 'monitor';" > /dev/null 2>&1 

printf "$POWDER_BLUE$BRIGHT[$(date)] MySQL Provisioning COMPLETE!$NORMAL\n"

