# frozen_string_literal: true

RSpec.describe Acme do
  it "has a version number" do
    expect(Acme::VERSION).not_to be_nil
  end

  it "defines a base error type" do
    expect(Acme::AcmeError).to be_a Class
    expect(Acme::AcmeError).to be < StandardError
  end

  it "requires the core modules" do
    expect(defined?(Acme::Connect)).to eql("constant")
    expect(defined?(Acme::Lookup)).to eql("constant")
    expect(defined?(Acme::Settlement)).to eql("constant")
    expect(defined?(Acme::Models::Merchant)).to eql("constant")
    expect(defined?(Acme::Models::Transaction)).to eql("constant")
  end
end
