#!/bin/bash
. constants
set -e
printf "Started MySQL Docker Cluster Provisioner...\n"

sleep 1

docker-compose up -d
./bin/docker-mysql-post.bash && ./bin/docker-proxy-post.bash && ./bin/docker-orchestrator-post.bash
