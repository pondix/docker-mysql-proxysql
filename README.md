ProxySQL / MySQL Docker Testing
===============================

This repository contains a docker-compose.yml used to launch a small cluster consisting of 3x
MySQL 5.7 containers (1x Master and 2x Slaves) and ProxySQL 1.4.x container all connected via 
a frontend / backend network. ProxySQL is automatically configured with 2x hostgroups, a writer 
hostgroup used as the default hostgroup and a reader hostgroup for all SELECT statements.

Once the cluster is initialised, replication is started and a sysbench dataset is prepared. After
that a short sysbench test is executed automatically. To launch a new cluster for the FIRST TIME please
execute the following command:

```bash
sudo ./docker-compose-init.bash
```

Thereafter you can just start and stop the cluster with regular `docker-compose` commands, for example:

```bash
sudo docker-compose stop
sudo docker-compose start
```

To stop the instances and remove the containers execute:

```bash
sudo ./docker-compose-destroy.bash
```

The MySQL instances (as well as ProxySQL) have separate directories with their respective configuration
in the conf directory. You can override any of the MySQL 5.7 variables by editing the `my.cnf` located
in the respective subdirectory under `conf` for each container (i.e. `conf/mysql-master/my.cnf`,
`conf/mysql-slave1/my.cnf` or `conf/mysql-slave2/my.cnf`).

Note that you'll need the following tools installed on your host machine:
- docker-ce / docker-ee (17.12+ recommended)
- docker-compose
- mysql-client (5.7+ recommended)
- sysbench (1.0.12+ recommended)

In addition if you prefer not to use docker-compose you'll also find two separate scripts for launching the 
MySQL and ProxySQL instances:
- docker-mysql.bash
- docker-proxysql.bash

If you would like to re-run the benchmark you can run:

```bash
bin/docker-benchmark.bash
```

This script will drop / create the sysbench database, create a test dataset and run the benchmark. You can
edit the file and tailor this behaviour as you would like. Please be aware that this is called during the 
provisioning stage so its best to copy the file in order to make your own benchmarks.
