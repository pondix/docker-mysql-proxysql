#!/bin/bash
printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Started ProxySQL / MySQL Docker Cluster Provisioner!                           #\n"
printf "##################################################################################\n"
printf "$NORMAL"

. constants

docker-compose up -d
./bin/docker-mysql-post.bash && ./bin/docker-proxy-post.bash && ./bin/docker-benchmark.bash
