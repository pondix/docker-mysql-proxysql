#!/bin/bash
mysql -hproxysql -P6032 -uradmin -pradmin -vvv -e"DELETE FROM mysql_servers WHERE hostname = '$1'; LOAD MYSQL SERVERS TO RUNTIME; SAVE MYSQL SERVERS TO DISK;" >> /tmp/proxysql.info
