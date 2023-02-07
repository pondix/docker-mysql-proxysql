#!/bin/bash

echo "Increasing connect_timeout and decreasing ai_delay_mp for ProxySQL... then setting HG-0 servers to OFFLINE_SOFT and disabling repl_hostgroup"
mysql -uradmin -pradmin -h127.0.0.1 -P16032 -e"
set mysql-connect_timeout_server_max=60000;
set mysql-auto_increment_delay_multiplex=0;
LOAD MYSQL VARIABLES TO RUNTIME; SAVE MYSQL VARIABLES TO DISK;

DELETE FROM mysql_replication_hostgroups
  WHERE writer_hostgroup=0 AND reader_hostgroup=1;

UPDATE mysql_servers SET status ='OFFLINE_SOFT' WHERE hostgroup_id=0;

LOAD MYSQL SERVERS TO RUNTIME; SAVE MYSQL SERVERS TO DISK;
"

echo "Pre-failover topology is:"
docker exec -ti orc1 bash -c "orchestrator-client -c topology -a mysql2:3306"

echo "Monitoring for connections used to drop to zero..."
CONNUSED="1"
while [ "${CONNUSED}" != "0" ]
do
  CONNUSED=`mysql -uradmin -pradmin -h127.0.0.1 -P16032 -e 'SELECT IFNULL(SUM(ConnUsed),0) FROM stats_mysql_connection_pool WHERE status="OFFLINE_SOFT" AND srv_host="mysql2"' -B -N 2>/dev/null`
  sleep 0.05
done

echo "Reconfiguring Orchestrator topology and performing failover from mysql2 to mysql1..."
docker exec -ti orc1 bash -c "orchestrator-client -c move-below -i mysql3 -d mysql1"
docker exec -ti orc1 bash -c "orchestrator-client -c graceful-master-takeover -a mysql2"

echo "Enabling repl_hostgroup, decreasing connect_timeout and increasing ai_delay_mp for ProxySQL"
mysql -uradmin -pradmin -h127.0.0.1 -P16032 -e"
-- DELETE FROM mysql_servers WHERE hostname = 'mysql2';
INSERT INTO mysql_replication_hostgroups (writer_hostgroup, reader_hostgroup) VALUES (0, 1);
LOAD MYSQL SERVERS TO RUNTIME; SAVE MYSQL SERVERS TO DISK;

set mysql-auto_increment_delay_multiplex=5;
set mysql-connect_timeout_server_max=10000;
LOAD MYSQL VARIABLES TO RUNTIME; SAVE MYSQL VARIABLES TO DISK;

"

docker exec -ti orc1 bash -c "orchestrator-client -c start-slave -i mysql2"

echo "Waiting for topology changes to propagate to all systems for verification..."

sleep 2

echo "New topology after a successful failover is:"
docker exec -ti orc1 bash -c "orchestrator-client -c topology -a mysql2:3306"

