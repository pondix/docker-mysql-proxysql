#!/bin/bash
. constants
export ORCHESTRATOR_API="http://localhost:23101/api http://localhost:23102/api http://localhost:23103/api"
printf "$YELLOW[$(date)] Orchestrator discovering mysql1 - "
orchestrator-client -c discover -i mysql1
printf "$YELLOW[$(date)] Orchestrator discovering mysql2 - "
orchestrator-client -c discover -i mysql2
printf "$YELLOW[$(date)] Orchestrator discovering mysql3 - "
orchestrator-client -c discover -i mysql3
printf "$LIME_YELLOW$BRIGHT[$(date)] Orchestrator discovery COMPLETE!\n"
printf "$POWDER_BLUE[$(date)]The following topology is available:$RED\n"
orchestrator-client -c topology -a $(orchestrator-client -c clusters)
printf "$LIME_YELLOW$BRIGHT[$(date)] Your cluster name is: $(orchestrator-client -c clusters)\n"
printf "${POWDER_BLUE}All provisioning actions have completed SUCCESSFULLY!$NORMAL\n"
