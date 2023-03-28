# frozen_string_literal: true

module BodyParsing

  UNPARSED_POST_BODY = Object.new.freeze
  TOP_LEVEL_ARRAY_POST_BODY = Object.new.freeze

  module Helpers
    def unparsed_post_body
      params[::BodyParsing::UNPARSED_POST_BODY]
    end

    def top_level_array_post_body
      params[::BodyParsing::TOP_LEVEL_ARRAY_POST_BODY]
    end

    def top_level_array_post_body?
      top_level_array_post_body.is_a?(Array)
    end
  end

  def self.registered(app)
    app.use Rack::Parser,
      logger: app.logger,
      parsers: {
        'application/json' => Proc.new do |body|
          parsed = ::MultiJson.load(body)
          parsed = {TOP_LEVEL_ARRAY_POST_BODY => parsed} if parsed.is_a?(::Array)
          parsed[UNPARSED_POST_BODY] = body.freeze if parsed.is_a?(::Hash)
          parsed
        end
      },
      handlers: {
        'application/json' => proc { |e, type| [400, {'Content-Type' => type}, ['{"error":"JSON body is malformed"}']] }
      }
    app.helpers Helpers
  end

end
