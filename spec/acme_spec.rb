# frozen_string_literal: true

RSpec.describe Acme do
  it "has a version number" do
    expect(Acme::VERSION).not_to be_nil
  end

  it "defines a base error type" do
    expect(Acme::AcmeError).to be_a Class
    expect(Acme::AcmeError).to be < StandardError
  end

  xit "requires the core modules" do
    expect(defined?(Acme::SomeImport)).to eql("constant")
  end
end
