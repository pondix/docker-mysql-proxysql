#!/bin/bash
. constants

printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Started ProxySQL / Group Replication / MySQL Docker Cluster Provisioner!       #\n"
printf "##################################################################################\n"
printf "$NORMAL"

sleep 1

docker-compose up -d
./bin/docker-mysql-post.bash && ./bin/docker-proxy-post.bash
