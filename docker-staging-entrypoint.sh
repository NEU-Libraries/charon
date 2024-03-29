#!/bin/bash
dockerize -wait tcp://db:5432 -timeout 1m
dockerize -wait http://solr:8983 -timeout 1m
rm -f /home/charon/web/tmp/pids/server.pid
rails db:migrate 2>/dev/null
rails assets:precompile
bundle exec rake leaflet:copy_images
bundle exec rake tinymce:copy_skins
rails s -p 3000 -b '0.0.0.0'
