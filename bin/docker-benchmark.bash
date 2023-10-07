#!/bin/bash

. constants

MYSQL_USER=sysbench
MYSQL_PWD=sysbench

# Override these defaults by exporting them in the command line prior to
# running the script
PREP_THREADS=${PREP_THREADS:=10}
RUN_THREADS=${RUN_THREADS:=32}
NUM_TABLES=${NUM_TABLES:=10}
SIZE_TABLES=${SIZE_TABLES:=10000}
REPORT_INTERVAL=${REPORT_INTERVAL:=5}
TIME=${TIME:=600}
BENCH_TEST=${BENCH_TEST:="/usr/share/sysbench/oltp_read_write.lua"}

printf "$RED[$(date)] Dropping 'sysbench' schema if present and preparing test dataset:$NORMAL\n"
mysql -h127.0.0.1 -P16033 -u$MYSQL_USER -p$MYSQL_PWD -e"DROP DATABASE IF EXISTS sysbench; CREATE DATABASE IF NOT EXISTS sysbench"

printf "$POWDER_BLUE[$(date)] Running Sysbench Benchmarks against ProxySQL:"
sysbench $BENCH_TEST --table-size=$SIZE_TABLES --tables=$NUM_TABLES --threads=$PREP_THREADS \
  --mysql-db=sysbench --mysql-user=$MYSQL_USER --mysql-password=$MYSQL_PWD --mysql-host=127.0.0.1 --mysql-port=16033 --db-driver=mysql \
  prepare

sleep 5

sysbench $BENCH_TEST --table-size=$SIZE_TABLES --tables=$NUM_TABLES --threads=$RUN_THREADS \
  --mysql-db=sysbench --mysql-user=$MYSQL_USER --mysql-password=$MYSQL_PWD --mysql-host=127.0.0.1 --mysql-port=16033 --db-driver=mysql \
  --db-ps-mode=disable --time=$TIME --report-interval=$REPORT_INTERVAL \
  run

printf "$POWDER_BLUE$BRIGHT[$(date)] Benchmarking COMPLETED!$NORMAL\n"
