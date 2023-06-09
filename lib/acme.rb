# frozen_string_literal: true

module Acme
  VERSION = "0.1.0"

  ROOT = File.expand_path('..', __dir__).freeze
  LIB  = File.join(ROOT, 'lib').freeze

  AcmeError = Class.new(StandardError)
  LookupError = Class.new(AcmeError)
  ApiError = Class.new(AcmeError)
end

def require_directory(directory, root: Acme::LIB, recursive: true)
  path = File.join(root, directory)
  glob = recursive ? "#{path}/**/*.rb" : "#{path}/*.rb"
  Dir[glob].sort.each { |file| require file }
end

require "faraday/typhoeus"
Faraday.default_adapter = :typhoeus

require "active_support"
require "active_support/core_ext/date"
require "active_support/core_ext/time"
Time.zone = 'UTC'

require "acme/connect"
require "acme/lookup"
require "acme/settlement"

require_directory "acme/models"
