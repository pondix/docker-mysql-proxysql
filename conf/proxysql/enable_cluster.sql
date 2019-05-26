SET admin-cluster_username='radmin';
SET admin-cluster_password='radmin';
LOAD ADMIN VARIABLES TO RUNTIME;
SAVE ADMIN VARIABLES TO DISK;
INSERT INTO proxysql_servers (hostname) VALUES ('proxysql1'),('proxysql2'),('proxysql3');
LOAD PROXYSQL SERVERS TO RUNTIME;
SAVE PROXYSQL SERVERS TO DISK;

