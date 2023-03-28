# frozen_string_literal: true

module Acme
  module Models
    Transaction = Data.define(
      :id,
      :created_at,
      :updated_at,
      :type,
      :amount,
      :customer,
      :merchant,
      :order
    )
  end
end
