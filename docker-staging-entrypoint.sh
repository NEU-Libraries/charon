#!/bin/bash
set -e
dockerize -wait tcp://db:5432 -timeout 1m
dockerize -wait http://solr:8983 -timeout 1m
rm -f /home/charon/web/tmp/pids/server.pid
rails db:migrate
rails s -p 3000 -b '0.0.0.0'