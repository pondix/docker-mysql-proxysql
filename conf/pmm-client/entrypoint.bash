#!/bin/bash

# Wait for pmm-server to start (this could be a loop checking the port)
sleep 15 

pmm-agent setup --debug --config-file=/usr/local/percona/pmm/config/pmm-agent.yaml --server-address=pmm-server:8443 --server-insecure-tls --server-username=admin --server-password=admin --force

# Add delay to ensure data is persisted
sleep 3

pmm-agent --config-file=/usr/local/percona/pmm/config/pmm-agent.yaml

# Add standard MySQL hosts
pmm-admin add mysql --username=root --password=root --query-source=perfschema mysql1 mysql1:3306
pmm-admin add mysql --username=root --password=root --query-source=perfschema mysql2 mysql2:3306
pmm-admin add mysql --username=root --password=root --query-source=perfschema mysql3 mysql3:3306

# Add ProxySQL hosts
pmm-admin add proxysql --username=radmin --password=radmin proxysql1 proxysql:6032
