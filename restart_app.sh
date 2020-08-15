#!/bin/bash

directoryArray=( pgdata/pg_wal/ pgdata/pg_tblspc/ pgdata/base pgdata/pg_replslot pgdata/pg_twophase pgdata/pg_stat_tmp pgdata/pg_stat pgdata/pg_snapshots pgdata/pg_xact pgdata/pg_commit_ts pgdata/pg_logical pgdata/pg_logical/snapshots pgdata/pg_logical/mappings )

docker-compose down 

for directoryPath in ${directoryArray[*]}
do
	if [ ! -d "${directoryPath}" ]; then
  		mkdir "${directoryPath}"
  		echo "Directory ${directoryPath} Created"
  	fi
done

yes | docker image prune
docker pull tarashagarwal/cart_app
docker pull postgres
docker pull ruby

docker-compose up -d --remove-orphans
# APP_CONTAINER_ID=$(docker ps | grep macallan_solidus_1 | awk "{print \$1}" | head -n 1)
# docker exec -it $APP_CONTAINER_ID bash