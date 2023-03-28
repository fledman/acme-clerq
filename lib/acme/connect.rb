# frozen_string_literal: true

module Acme
  module Connect
    extend self

    URL = 'https://api-engine-dev.clerq.io/tech_assessment'

    ERROR = Data.define(:status, :response)

    def customers(params:)
      fetch(path: 'customers/', params:)
    end

    def merchants(params:)
      fetch(path: 'merchants/', params:)
    end

    def orders(params:)
      fetch(path: 'orders/', params:)
    end

    def transactions(params:)
      fetch(path: 'transactions/', params:)
    end

    private

    def connection
      Faraday.new(url: URL)
    end

    def fetch(path:, params:, tries: 3)
      resp = connection.get(path, params)
      return JSON.parse(resp.body) if resp.success?
      left = tries - 1
      return ERROR.new(status: resp.status, response: resp) if left <= 0
      sleep(0.2)
      fetch(path:, params:, tries: left)
    end

  end
end
