# frozen_string_literal: true

$stdout.sync = true

require_relative 'config/environment'

map '/api' do
  run ApiApplication
end
