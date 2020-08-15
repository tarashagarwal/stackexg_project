unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac


export POSTGRES_USER=tarash
export POSTGRES_PASSWORD=abc123
export POSTGRES_PORT=54321
export DATABASE_NAME=cart_app
export POSTGRES_HOST=localhost
APP_CONTAINER_ID=$(docker ps | grep macallan_solidus_1 | awk "{print \$1}" | head -n 1)
if [  -z $APP_CONTAINER_ID ];then
	docker-compose down
	yes | docker image prune
	docker-compose -f docker-compose.yml up -d
	APP_CONTAINER_ID=$(docker ps | grep macallan_solidus_1 | awk "{print \$1}" | head -n 1)
	docker exec -it $APP_CONTAINER_ID rails c
else
	docker exec -it $APP_CONTAINER_ID rails c
fi



# if [ $machine == "Mac" ]; then

# elif [ $machine == "Linux" ]; then
# 	cd app && bundle
# 	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# 	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# 	apt-get update && apt-get install yarn
# 	yarn install --check-files
# fi