#!/bin/bash
set -e
./scripts/wait-for-it.sh -t 60 db:5432 --strict -- echo "db is up"
./scripts/wait-for-it.sh -t 60 solr:8983 --strict -- echo "solr is up"
rm -f /home/charon/web/tmp/pids/server.pid
rake db:create
rake db:migrate
rake db:migrate RAILS_ENV=test
rails s -p 3000 -b '0.0.0.0'
