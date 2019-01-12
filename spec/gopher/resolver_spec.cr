require "../spec_helper"

class SpecResolver < Gopher::Resolver
  def resolve(_req)
    Gopher::Response.error("BOOM")
  end

  def menu_entry_type
    Gopher::MenuEntryType::Error
  end
end

module Gopher
  describe Resolver do
    describe "default values" do
      it "are correct" do
        resolver = SpecResolver.new

        expect(resolver.default_host).must_equal("localhost")
        expect(resolver.default_port).must_equal(70_u16)
      end
    end
  end
end
