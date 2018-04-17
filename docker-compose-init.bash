#!/bin/bash
. constants

printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Started ProxySQL / Orchestrator / MySQL Docker Cluster Provisioner!            #\n"
printf "##################################################################################\n"
printf "$NORMAL"

sleep 1

docker-compose up -d
./bin/docker-mysql-post.bash && ./bin/docker-proxy-post.bash && ./bin/docker-orchestrator-post.bash

### Start binlog_reader
docker-compose exec mysql1 bin/bash -c "apt update && apt -y install libboost-system1.55.0 && /opt/proxysql_mysqlbinlog/proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log &"
docker-compose exec mysql2 bin/bash -c "apt update && apt -y install libboost-system1.55.0 && /opt/proxysql_mysqlbinlog/proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log &"
docker-compose exec mysql3 bin/bash -c "apt update && apt -y install libboost-system1.55.0 && /opt/proxysql_mysqlbinlog/proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log &"
