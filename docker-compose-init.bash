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

### Copy prerequisites
docker cp conf/proxysql/binaries/libboost-system1.55.0_1.55.0+dfsg-3_amd64.deb docker-mysql-proxysql_mysql1_1:/root/
docker cp conf/proxysql/binaries/libboost-system1.55.0_1.55.0+dfsg-3_amd64.deb docker-mysql-proxysql_mysql2_1:/root/
docker cp conf/proxysql/binaries/libboost-system1.55.0_1.55.0+dfsg-3_amd64.deb docker-mysql-proxysql_mysql3_1:/root/

### Start binlog_reader
docker-compose exec mysql1 bin/bash -c "apt update && apt install libssl1.0.2 && ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.2 /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 && ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.2 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 && dpkg -i /root/libboost-system1.55.0_1.55.0+dfsg-3_amd64.deb && /opt/proxysql_mysqlbinlog/proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log"
docker-compose exec mysql2 bin/bash -c "apt update && apt install libssl1.0.2 && ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.2 /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 && ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.2 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 && dpkg -i /root/libboost-system1.55.0_1.55.0+dfsg-3_amd64.deb && /opt/proxysql_mysqlbinlog/proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log"
docker-compose exec mysql3 bin/bash -c "apt update && apt install libssl1.0.2 && ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.2 /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 && ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.2 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 && dpkg -i /root/libboost-system1.55.0_1.55.0+dfsg-3_amd64.deb && /opt/proxysql_mysqlbinlog/proxysql_binlog_reader -h 127.0.0.1 -u root -p root -P 3306 -l 999 -L /var/log/binlog_reader.log"
