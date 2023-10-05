ProxySQL / Orchestrator / MySQL Docker Testing
==============================================

This repository contains a docker-compose.yml used to launch a small cluster consisting of 3x
MySQL 8.0 containers (1x Primary and 2x Replicas), 3x Orchestrator nodes connected via RAFT and 
a ProxySQL (latest) container all connected via a frontend / backend network as well as Percona
PMM for monitoring the instances. ProxySQL is automatically configured with 2x hostgroups, a 
writer hostgroup used as the default hostgroup and a reader hostgroup for all SELECT statements.

Once the cluster is initialised, replication is started and a sysbench dataset is prepared. After
that a short sysbench test is executed automatically. To launch a new cluster for the FIRST TIME please
execute the following command:

```bash
# To start with benchmarks:
sudo ./docker-compose-init.bash

# To skip benchmarking:
sudo ./docker-compose-init.bash nobench
```

Thereafter you can just start and stop the cluster with regular `docker-compose` commands, for example:

```bash
sudo docker-compose stop
sudo docker-compose start
```

To stop the instances and destroy the containers execute:

```bash
sudo ./docker-compose-destroy.bash
```

The MySQL, Orchestrator and ProxySQL hosts have separate directories with their respective configuration
in the conf directory. You can override any of the MySQL 8.0 variables by editing the `my.cnf` located
in the respective subdirectory under `conf` for each container (i.e. `conf/mysql/mysql1/my.cnf`,
`conf/mysql/mysql2/my.cnf` or `conf/mysql/mysql3/my.cnf`). Its also possible to edit the ProxySQL and
Orchestrator config files as needed.

Note that you'll want the following pre-requisites installed on your host machine:
- docker-ce / docker-ee (17.12+ required, see https://docs.docker.com/engine/install)
- docker-compose (1.19+ required)
- mysql-client (5.7+ required)
- sysbench (1.0.12+ recommended if benchmarking)
- orchestrator-client (3.0.8+ recommended if administering Orchestrator via CLI)
- jq (required for Orchestrator)

Sample instructions for installing on Ubuntu 20.04:
```
# Install pre-requisites for Docker-CE & toolkit
sudo apt-get install apt-transport-https ca-certificates curl git gnupg jq lsb-release sysbench
git clone https://github.com/sysown/docker-mysql-proxysql.git

# Install Docker-CE keyring
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker-CE packages
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Install Orchestrator client package
wget https://github.com/openark/orchestrator/releases/download/v3.2.4/orchestrator-client_3.2.4_amd64.deb
sudo dpkg -i ./orchestrator-client_3.2.4_amd64.deb 

# Start containers
cd docker-mysql-proxysql/
./docker-compose-init.bash 
```

If you would like to run the benchmark just execute:

```bash
bin/docker-benchmark.bash
```

This script will drop / create the sysbench database, create a test dataset and run the benchmark. You can
edit the file and tailor this behaviour as you would like. Please be aware that this is called during the 
provisioning stage so its best to make a copy of the file with your own benchmarks.

