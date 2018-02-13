#!/bin/bash
. constants
printf "$YELLOW[$(date)] Provisioning ProxySQL container 1...$NORMAL\n"

if [[ "$(sudo docker images -q proxysql:1.4.x 2> /dev/null)" == "" ]]; then
  printf "$YELLOW[$(date)] Building ProxySQL 1.4.x Image...$NORMAL\n"
  sudo docker build -t proxysql:1.4.x $(pwd)/conf/  
fi

sudo docker run -d -p 16033:6033 -p 16032:6032 --net=$NETWORK_NAME \
 --name=proxysql1 \
 -v $(pwd)/conf/proxysql/proxysql.cnf:/etc/proxysql.cnf \
 -d proxysql:1.4.x

printf "$GREEN[$(date)] Started ProxySQL container (1): $(sudo docker ps -l -q)$NORMAL\n"
