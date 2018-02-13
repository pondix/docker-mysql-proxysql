#!/bin/bash
. constants
printf "$YELLOW[$(date)] Provisioning ProxySQL container 1...$NORMAL\n"

sudo docker run -d -p 16033:6033 -p 16032:6032 --net=$NETWORK_NAME \
 --name=proxysql1 \
 -v $(pwd)/conf/proxysql/proxysql.cnf:/etc/proxysql.cnf \
 -d pondix/proxysql:latest

printf "$GREEN[$(date)] Started ProxySQL container (1): $(sudo docker ps -l -q)$NORMAL\n"
