# frozen_string_literal: true

require 'bigdecimal'

module Acme
  module Settlement
    extend self

    def execute(merchant_input:, date:)
      merchant = lookup_merchant(input: merchant_input)
      raise ApiError, "unknown merchant: #{merchant_input.inspect}" if merchant.nil?

      window       = transaction_window(date:)
      transactions = Lookup.transactions(merchant: merchant.id, **window)
      amount       = settle(transactions:)
      
      {
        amount:             amount,
        transaction_count:  transactions.size,
        transactions:       transactions.map(&:id),
        merchant:           {id: merchant.id, name: merchant.name},
        window:             window,
      }
    end

    private

    def settle(transactions:)
      transactions.map do |t|
        amount = BigDecimal(t.amount)
        case t.type
        when "SALE", "PURCHASE"
          amount
        when "REFUND"
          -1 * amount
        else
          raise ApiError, "invalid transaction type: #{t.type.inspect}"
        end
      end.reduce(0,:+).to_f.round(2)
    end

    def known_merchants
      @known_merchants ||= begin
        timestamp = Time.current.to_fs(:iso8601)
        list = Lookup.merchants(created_at__lte: timestamp)
        {timestamp:, list:}
      end
    end

    def lookup_merchant(input:)
      found = known_merchants[:list].find{ |m| m.name == input || m.id == input }
      return found if found
      newer = Lookup.merchants(created_at__gt: known_merchants[:timestamp])
      newer.find{ |m| m.name == input || m.id == input }
    end

    def transaction_window(date:)
      # TODO support variable time zones

      date = coerce_date(date:)
      raise ApiError, "no settlement on weekends!" if date.saturday? || date.sunday?
      
      if date.monday?
        start = date - 3
      else
        start = date - 1
      end

      gt  = start.to_time(:utc).change(hour: 17)
      lte = date.to_time(:utc).change(hour: 17)

      {
        created_at__gt:  gt.to_fs(:iso8601),
        created_at__lte: lte.to_fs(:iso8601),
      }
    end

    def coerce_date(date:)
      case date
      when Date
        date
      when String
        Date.parse(date)
      else
        raise ApiError, "invalid date: #{date.inspect}"
      end
    rescue Date::Error => err
      raise ApiError, "invalid date string"
    end

  end
end
