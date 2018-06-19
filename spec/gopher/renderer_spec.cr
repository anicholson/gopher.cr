require "../spec_helper"

module Gopher
  describe Renderer do
    let(:renderer) { Renderer.new }
    let(:client) { IO::Memory.new }

    describe "#render" do
      describe "rendering an error" do
        let(:item) { Response.error("This didn't work") }

        it "contains the error message" do
          renderer.render(client, item)
          client.rewind
          lines = client.gets_to_end.split(/[\r\n]+/)

          error_provided = lines.one? { |line| line.match /#{item.error}/ }

          expect(error_provided).must_equal(true)
        end
      end

      describe "rendering a menu" do
      end

      describe "rendering an item" do
        describe "rendering a text item" do
        end

        describe "rendering a binary item" do
        end
      end
    end
  end
end
