#!/bin/bash
. constants

printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Stopping ProxySQL / Orchestrator / MariaDB Docker Cluster instances!             #\n"
printf "##################################################################################\n"
printf "$NORMAL"

docker-compose stop
docker-compose rm -f
docker volume prune -f
docker network prune -f
printf "$POWDER_BLUE$BRIGHT[$(date)] Deprovisioning COMPLETE!$NORMAL\n"

