# frozen_string_literal: true

module Acme
  module Models
    Merchant = Data.define(
      :id,
      :created_at,
      :updated_at,
      :name
    )
  end
end
