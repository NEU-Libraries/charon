#!/bin/bash
set -e

rm -f /home/charon/web/tmp/pids/server.pid
rake db:create
rake db:migrate
rake db:migrate RAILS_ENV=test
rails s -p 3000 -b '0.0.0.0'
