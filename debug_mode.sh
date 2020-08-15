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

docker-compose down
docker-compose -f docker-compose-debug.yml down
yes | docker image prune
docker-compose -f docker-compose-debug.yml up -d
cd app

if [ -f "/app/tmp/pids/server.pid" ]; then
	rm -rf /app/tmp/pids/server.pid
fi

yarn && rails s -b 0.0.0.0 -p 3000

# if [ $machine == "Mac" ]; then

# elif [ $machine == "Linux" ]; then
# 	cd app && bundle
# 	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# 	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# 	apt-get update && apt-get install yarn
# 	yarn install --check-files
# fi