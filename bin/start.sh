#!/usr/bin/env sh

bundle check || bundle install
RACK_ENV=production bundle exec puma -C config/puma.rb