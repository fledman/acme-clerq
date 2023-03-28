# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/custom_logger'

require_relative 'body_parsing'

class ApiApplication < Sinatra::Base

  helpers Sinatra::CustomLogger

  configure do
    set :logger, Logger.new(STDOUT, level: :warn)
  end

  register BodyParsing

  error Sinatra::NotFound do
    status 400
    json(code: 400, error: 'invalid request')
  end

  error Acme::LookupError do
    status 503
    json(code: 503, error: "ACME is having reliability issues, please retry")
  end

  error Acme::ApiError do
    status 400
    json(code: 400, error: env['sinatra.error'].message)
  end

  get '/' do
    json(testing: 123)
  end

  post '/echo' do
    json(params.select{ |k,_| k.is_a?(String) })
  end

  get '/merchants' do
    json(Acme::Lookup.merchants.map(&:to_h))
  end

  post '/settle' do
    merchant_input, date = params['merchant'], params['date']
    result = Acme::Settlement.execute(merchant_input:, date:)
    json(result)
  end

end
