#!/bin/bash
. constants

printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Starting MySQL / ProxySQL / Orchestrator / PMM Docker Cluster provisioner!     #\n"
printf "##################################################################################\n"
printf "$NORMAL"

docker-compose up -d
./bin/docker-mysql-post.bash && ./bin/docker-proxy-post.bash && ./bin/docker-orchestrator-post.bash && ./bin/docker-pmm-client-bootstrap.bash

if [[ -z "$1" ]]; then
  sleep 2
  ./bin/docker-benchmark.bash
fi
