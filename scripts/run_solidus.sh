#!/bin/sh

cd /usr/src/app
echo "Solidus starting ... "
/bin/post_init.sh
echo "Removing previous server PID File ... "
if [ -f "tmp/pids/server.pid" ];then 
	rm tmp/pids/server.pid
fi
yarn
rails server -b 0.0.0.0
