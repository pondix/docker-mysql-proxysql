#!/bin/bash
printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Stopping ProxySQL / MySQL Docker Cluster...                                    #\n"
printf "##################################################################################\n"
printf "$NORMAL"

. constants

docker-compose stop
docker-compose rm -f
printf "$POWDER_BLUE$BRIGHT[$(date)] Deprovisioning COMPLETE!$NORMAL\n"

