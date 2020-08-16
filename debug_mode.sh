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


directoryArray=( pgdata/pg_wal/ pgdata/pg_tblspc/ pgdata/base pgdata/pg_replslot pgdata/pg_twophase pgdata/pg_stat_tmp pgdata/pg_stat pgdata/pg_snapshots pgdata/pg_xact pgdata/pg_commit_ts pgdata/pg_logical pgdata/pg_logical/snapshots pgdata/pg_logical/mappings )

docker-compose down 

for directoryPath in ${directoryArray[*]}
do
	if [ ! -d "${directoryPath}" ]; then
  		mkdir "${directoryPath}"
  		echo "Directory ${directoryPath} Created"
  	fi
done

docker-compose -f docker-compose-debug.yml down
yes | docker image prune
docker-compose -f docker-compose-debug.yml up -d
cd app

if [ -f "/app/tmp/pids/server.pid" ]; then
	rm -rf /app/tmp/pids/server.pid
fi

yarn && rails s -b 0.0.0.0 -p 80

# if [ $machine == "Mac" ]; then

# elif [ $machine == "Linux" ]; then
# 	cd app && bundle
# 	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# 	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# 	apt-get update && apt-get install yarn
# 	yarn install --check-files
# fi