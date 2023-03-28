# frozen_string_literal: true

require 'rack'

module Acme
  module Lookup
    extend self

    def customers(**params)
      follow(route: :customers, params:).then do |r|
        parse(model: Acme::Models::Customer, results: r)
      end
    end

    def merchants(**params)
      follow(route: :merchants, params:).then do |r|
        parse(model: Acme::Models::Merchant, results: r)
      end
    end

    def orders(**params)
      follow(route: :orders, params:).then do |r|
        parse(model: Acme::Models::Order, results: r)
      end
    end

    def transactions(**params)
      follow(route: :transactions, params:).then do |r|
        parse(model: Acme::Models::Transaction, results: r)
      end
    end

    private

    def follow(route:, params:)
      results = []
      page = Connect.public_send(route, params:)
      raise LookupError, "connection error: #{page.status}" if Connect::ERROR === page
      results += page['results']
      total = page['count']
      while page['next']
        query = query_params(page['next'])
        cont  = query['page']
        page  = Connect.public_send(route, params: params.merge(page: cont))
        raise LookupError, "connection error: #{page.status}" if Connect::ERROR === page
        results += page['results']
      end
      raise LookupError, "expected total (#{total}) does not match result set (#{results.size})" if total != results.size
      results
    end

    def query_params(url)
      Rack::Utils.parse_nested_query(URI.parse(url).query)
    end

    def parse(model:, results:)
      results.map{ |res| model.new(**res.transform_keys(&:to_sym)) }
    end

  end
end
