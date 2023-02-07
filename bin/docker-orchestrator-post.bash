#!/bin/bash
. constants
export ORCHESTRATOR_API="http://localhost:23101/api http://localhost:23102/api http://localhost:23103/api"
printf "$YELLOW[$(date)] Orchestrator discovering mysql1 - "
docker exec -ti orc1 bash -c "orchestrator-client -c discover -i mysql1"
printf "$YELLOW[$(date)] Orchestrator discovering mysql2 - "
docker exec -ti orc1 bash -c "orchestrator-client -c discover -i mysql2"
printf "$YELLOW[$(date)] Orchestrator discovering mysql3 - "
docker exec -ti orc1 bash -c "orchestrator-client -c discover -i mysql3"
printf "$LIME_YELLOW$BRIGHT[$(date)] Orchestrator discovery COMPLETE!\n"
printf "$POWDER_BLUE[$(date)]The following topology is available:$RED\n"
docker exec -ti orc1 bash -c "orchestrator-client -c topology -a mysql1:3306"
printf "$LIME_YELLOW$BRIGHT[$(date)] Your cluster name is: mysql1:3306\n"

# Fixing errant transactions caused by time_zone table truncation in Oracle MySQL 5.7 container
printf "[$(date)] Checking and correcting system table related errant transactions on replicas\n"
docker exec -ti orc1 bash -c "orchestrator-client -c gtid-errant-inject-empty -i mysql2"
docker exec -ti orc1 bash -c "orchestrator-client -c gtid-errant-inject-empty -i mysql3"

