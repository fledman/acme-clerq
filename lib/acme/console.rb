# frozen_string_literal: true

module Acme
  module Console
    def self.irb!
      IRB::ExtendCommandBundle.include(Console)
    end

    # add console import functions here
  end
end
