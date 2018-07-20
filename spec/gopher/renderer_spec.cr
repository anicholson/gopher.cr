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
        let(:item) do
          Response.ok(Menu.new([
            MenuEntry.new(entry_type: MenuEntryType::Info, selector: "NULL", description: "Hello, menu", host: "nullhost", port: 70_u16),
            MenuEntry.new(entry_type: MenuEntryType::TextFile, selector: "/about.txt", description: "Le text", host: "nullhost", port: 70_u16),
            MenuEntry.new(entry_type: MenuEntryType::Submenu, selector: "/1/Stuff", description: "More stuff", host: "nullhost", port: 70_u16),
          ]))
        end

        it "ends with a ." do
          renderer.render(client, item)
          client.rewind

          lines = client.gets_to_end.split(/[\r\n]+/)

          expect(lines.last).must_equal(".")
        end

        it "contains a line for each entry" do
          renderer.render(client, item)
          client.rewind

          lines = client.gets_to_end.split(/[\r\n]+/)

          expect(lines.size).must_equal(item.value.as(Menu).entries.size + 1) # extra one is for  the "."
        end
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
