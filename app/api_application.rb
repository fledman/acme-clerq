# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/json'

class ApiApplication < Sinatra::Base

  get '/' do
    json(testing: 123)
  end

end
