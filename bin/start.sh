#!/usr/bin/env sh

bundle check || bundle install
bundle exec puma -C config/puma.rb