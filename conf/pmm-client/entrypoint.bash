#!/bin/bash

# Wait for pmm-server to start (this could be a loop checking the port)
sleep 15 

pmm-agent setup --config-file=/usr/local/percona/pmm2/config/pmm-agent.yaml --server-address=pmm-server --server-insecure-tls --server-username=admin --server-password=admin

# Add delay to ensure data is persisted
sleep 3

pmm-agent --config-file=/usr/local/percona/pmm2/config/pmm-agent.yaml

# Add standard MySQL hosts
pmm-admin add mysql --username=root --password=root --tls --tls-skip-verify --server-url=http://admin:admin@pmm-server --query-source=perfschema mysql1 mysql1:3306
pmm-admin add mysql --username=root --password=root --tls --tls-skip-verify --server-url=http://admin:admin@pmm-server --query-source=perfschema mysql2 mysql2:3306
pmm-admin add mysql --username=root --password=root --tls --tls-skip-verify --server-url=http://admin:admin@pmm-server --query-source=perfschema mysql3 mysql3:3306

