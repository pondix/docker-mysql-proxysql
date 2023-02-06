#!/bin/bash
. constants

printf "$YELLOW[$(date)] Waiting for PMM Client service configuration"

RC=1
while [ $RC -eq 1 ]
do
  sleep 1
  printf "."
  docker exec pmm-client pmm-admin status > /dev/null 2>&1
  RC=$?
done

printf "$LIME_YELLOW\n"

printf "$POWDER_BLUE[$(date)] Configuring mysql1 agent...$LIME_YELLOW\n"
docker exec pmm-client pmm-admin add mysql --username=root --password=root --tls --tls-skip-verify --server-url=http://admin:admin@pmm-server --query-source=perfschema mysql1 mysql1:3306

printf "$POWDER_BLUE[$(date)] Configuring mysql2 PMM agent...$LIME_YELLOW\n"
docker exec pmm-client pmm-admin add mysql --username=root --password=root --tls --tls-skip-verify --server-url=http://admin:admin@pmm-server --query-source=perfschema mysql2 mysql2:3306

printf "$POWDER_BLUE[$(date)] Configuring mysql3 PMM agent...$LIME_YELLOW\n"
docker exec pmm-client pmm-admin add mysql --username=root --password=root --tls --tls-skip-verify --server-url=http://admin:admin@pmm-server --query-source=perfschema mysql3 mysql3:3306

printf "${POWDER_BLUE}All provisioning actions have completed SUCCESSFULLY!$NORMAL\n"

