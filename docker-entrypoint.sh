#!/bin/sh

# Exit on fail
set -e

# Bundle install
gem install bundler -v '2.4.7'
bundle install --jobs=4

# Waiting for dependent containers
/wait-for-it.sh db:3306

# Migrate
bundle exec rake db:create
bundle exec rake db:migrate

# Remove puma pid if existed
rm -f tmp/pids/server.pid

# Start services

RAILS_PORT=8080

if [ -n "$PORT" ]; then
  RAILS_PORT=$PORT
fi

bundle exec rails server -p $RAILS_PORT -b 0.0.0.0

# Finally call command issued to the docker service
exec "$@"
