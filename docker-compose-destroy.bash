#!/bin/bash
. constants

printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Stopping MySQL / ProxySQL / Orchestrator / PMM Docker Cluster instances!             #\n"
printf "##################################################################################\n"
printf "$NORMAL"

docker-compose stop
docker-compose rm -f
docker volume prune -f
docker network prune -f
printf "$POWDER_BLUE$BRIGHT[$(date)] Deprovisioning COMPLETE!$NORMAL\n"

# PMM test logic
#docker stop pmm-client
#docker rm -f pmm-client-data
