#!/bin/bash

echo "Current orchestrator topology is:"
docker exec -ti orc1 bash -c "orchestrator-client -c topology -a mysql1:3306"

