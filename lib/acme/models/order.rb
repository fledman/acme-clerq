# frozen_string_literal: true

module Acme
  module Models
    Order = Data.define(
      :id,
      :created_at,
      :updated_at,
      :type,
      :total_amount,
      :trace_id,
      :parent_order,
      :customer,
      :merchant,
      :items_data,
      :transactions
    ) do

      def initialize(parent_order: nil, **rest)
        super(parent_order:, **rest)
      end

    end
  end
end
