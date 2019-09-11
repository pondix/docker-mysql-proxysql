#!/bin/bash
. constants
export ORCHESTRATOR_API="http://localhost:23101/api http://localhost:23102/api http://localhost:23103/api"
printf "[$(date)] Orchestrator discovering mysql1 - "
orchestrator-client -c discover -i mysql1
printf "[$(date)] Orchestrator discovering mysql2 - "
orchestrator-client -c discover -i mysql2
printf "[$(date)] Orchestrator discovering mysql3 - "
orchestrator-client -c discover -i mysql3
printf "[$(date)] Orchestrator discovery COMPLETE!\n"
printf "[$(date)]The following topology is available:\n"
orchestrator-client -c topology -a $(orchestrator-client -c clusters)
printf "[$(date)] Your cluster name is: $(orchestrator-client -c clusters)\n"
printf "All provisioning actions have completed SUCCESSFULLY!\n"
