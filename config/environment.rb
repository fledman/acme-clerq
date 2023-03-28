# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'
ENV['APP_ENV']  ||= ENV['RACK_ENV']

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

lib_dir = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

app_dir = File.expand_path("../../app", __FILE__)
$LOAD_PATH.unshift(app_dir) unless $LOAD_PATH.include?(app_dir)

require "acme"
require "api_application"
