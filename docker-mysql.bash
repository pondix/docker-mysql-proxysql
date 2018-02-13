#!/bin/bash
. constants

printf "$YELLOW[$(date)] Provisioning master MySQL server...$NORMAL\n"
# CREATE NEW CONTAINERS
sudo docker run -d -p 13306:3306 --net=$NETWORK_NAME \
 --name=mysql-master \
 -v $(pwd)/conf/mysql-master:/etc/mysql/conf.d \
 -e MYSQL_ROOT_PASSWORD="$MYSQL_PWD" \
 -d mysql:5.7

printf "$GREEN[$(date)] Started master MySQL server: $(sudo docker ps -l -q)$NORMAL\n"

printf "$YELLOW[$(date)] Provisioning slave MySQL server 1...$NORMAL\n"
sudo docker run -d -p 13307:3306 --net=$NETWORK_NAME \
 --name=mysql-slave1 \
 -v $(pwd)/conf/mysql-slave1:/etc/mysql/conf.d \
 -e MYSQL_ROOT_PASSWORD="$MYSQL_PWD" \
 -d mysql:5.7

printf "$GREEN[$(date)] Started slave MySQL server (1): $(sudo docker ps -l -q)$NORMAL\n"

printf "$YELLOW[$(date)] Provisioning slave MySQL server 2...$NORMAL\n"
sudo docker run -d -p 13308:3306 --net=$NETWORK_NAME \
 --name=mysql-slave2 \
 -v $(pwd)/conf/mysql-slave2:/etc/mysql/conf.d \
 -e MYSQL_ROOT_PASSWORD="$MYSQL_PWD" \
 -d mysql:5.7

printf "$GREEN[$(date)] Started slave MySQL server (2): $(sudo docker ps -l -q)$LIME_YELLOW\n"

