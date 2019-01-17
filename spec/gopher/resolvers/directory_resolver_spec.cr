require "../../spec_helper"

module Gopher
  describe DirectoryResolver do
    let(:config) { Config.new listen_host: "nomatter", listen_port: 70_u16, public_host: "localhost", public_port: 70_u16 }

    let(:dr) do
      root_path : String = File.expand_path("./spec/resources/example_directory")
      DirectoryResolver.new(root_path: root_path, root_selector: "/1files", config: config)
    end

    let(:req) { RequestBody.new("/") }

    describe "root request" do
      it "is okay" do
        result = dr.resolve(req)
        expect(result.ok?).must_equal(true)
      end

      it "returns a menu" do
        result = dr.resolve(req)

        expect(result.value.class).must_equal(Menu)
      end

      it "is not empty" do
        result = dr.resolve(req)
        menu = result.value.as Menu

        expect(menu.entries.size > 0).must_equal(true)
      end

      it "lists text files as text entries" do
        DirectoryResolver::TEXT_EXTENSIONS.each do |ext|
          result = dr.resolve(req)
          menu = result.value.as Menu

          ipsum = menu.entries.count do |entry|
            entry.entry_type == MenuEntryType::TextFile &&
              entry.selector == "/1files/0test#{ext}"
          end

          expect(ipsum).must_equal(1)
        end
      end

      it "includes submenus" do
        result = dr.resolve(req)
        menu = result.value.as Menu

        submenu = menu.entries.count do |entry|
          entry.entry_type == MenuEntryType::Submenu &&
            entry.selector == "/1files/1games"
        end

        expect(submenu).must_equal(1)
      end
    end

    describe "Requesting a file selector" do
      it "works" do
        req = RequestBody.new("/1files/0ipsum.txt")

        result = dr.resolve(req)
        resource = result.value.as Resource
        expected_content = File.read(File.expand_path("./spec/resources/example_directory/ipsum.txt"))

        expect(resource.content.gets_to_end).must_equal(expected_content)
      end
    end

    describe "Requesting a submenu selector" do
      it "reads the .gopermap from the relative path" do
        req = RequestBody.new("/1files/1games")

        result = dr.resolve(req)

        menu = result.value.as Menu

        info_messages = menu.entries.count do |entry|
          entry.entry_type == MenuEntryType::Info
        end

        expect(info_messages).must_equal(1)
      end

      it "handles trailing slashes correctly" do
        req = RequestBody.new("/1files/1games/")

        result = dr.resolve(req)

        menu = result.value

        expect(menu.class).must_equal(Menu)
      end

      it "can determine the submenu based on filetype" do
        req = RequestBody.new("/1files/1looks_like_a_file_but_is_a.directory")

        result = dr.resolve(req)

        expect(result.value.class).must_equal(Menu)
      end
    end

    describe "Requesting a menu item from a submenu" do
      it "retrieves the resource" do
        expected_content = File.read(File.expand_path("./spec/resources/example_directory/looks_like_a_file_but_is_a.directory/lol.txt"))
        req = RequestBody.new("/1files/1looks_like_a_file_but_is_a.directory/0lol.txt")

        result = dr.resolve(req)

        expect(result.value.class).must_equal(Resource)

        resource = result.value.as Resource
        expect(resource.content.gets_to_end).must_equal(expected_content)
      end
    end
  end
end
