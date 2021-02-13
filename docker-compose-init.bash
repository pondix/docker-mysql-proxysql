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
docker-compose exec mysql1 bin/bash -c "apt update && apt install -y wget libboost-system1.67.0 && wget https://github.com/sysown/proxysql_mysqlbinlog/releases/download/v1.0/proxysql-mysqlbinlog_1.0-debian10_amd64.deb && apt install -y ./proxysql-mysqlbinlog_1.0-debian10_amd64.deb && proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log"

docker-compose exec mysql2 bin/bash -c "apt update && apt install -y wget libboost-system1.67.0 && wget https://github.com/sysown/proxysql_mysqlbinlog/releases/download/v1.0/proxysql-mysqlbinlog_1.0-debian10_amd64.deb && apt install -y ./proxysql-mysqlbinlog_1.0-debian10_amd64.deb && proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log"

docker-compose exec mysql3 bin/bash -c "apt update && apt install -y wget libboost-system1.67.0 && wget https://github.com/sysown/proxysql_mysqlbinlog/releases/download/v1.0/proxysql-mysqlbinlog_1.0-debian10_amd64.deb && apt install -y ./proxysql-mysqlbinlog_1.0-debian10_amd64.deb && proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log"

