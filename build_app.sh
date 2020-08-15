#!/bin/bash


./build_and_push_cart_image.sh

if [[ -d "pgdata" ]] && [[ ! -d "app" ]]; then
	rm -rf pgdata/
fi

if [[ -d "state" ]]; then
	rm -rf state/
fi

if [ -f "docker.log" ]; then
	rm docker.log
fi

yes | docker image prune
docker pull tarashagarwal/cart_app
docker pull postgres
docker pull ruby

if [[ -d "temp_app" ]]; then
	rm -rf temp_app
fi

docker-compose up --force-recreate --build