#!/bin/bash
. constants
printf "$POWDER_BLUE[$(date)] Restarting binlog readers...$LIME_YELLOW\n"
docker-compose restart binlog_reader1
docker-compose restart binlog_reader2
docker-compose restart binlog_reader3
