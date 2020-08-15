#!/bin/sh

cd /tmp

## install rails
cp Gemfile-rails Gemfile
bundle install
bundle update

## create a throwaway app with pg as the database
## to get the gems installed
rails new app -d postgresql
cat Gemfile-solidus >> app/Gemfile
cd app
# pg 1.2.2 is stable for debugging with mac  refer: https://stackoverflow.com/questions/59846019/rails-postgres-dyld-lazy-symbol-binding-failed-symbol-not-found-pqresultme/60513513#60513513
sed -i -e "s/gem 'pg'.*/gem 'pg', '1.2.2'/" Gemfile
bundle install
bundle update
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn

cp Gemfile ..
