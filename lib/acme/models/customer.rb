# frozen_string_literal: true

module Acme
  module Models
    Customer = Data.define(
      :id,
      :created_at,
      :updated_at,
      :first_name,
      :last_name,
      :phone,
      :address,
      :email
    ) do

      def initialize(address: nil, **rest)
        super(address:, **rest)
      end

    end
  end
end
