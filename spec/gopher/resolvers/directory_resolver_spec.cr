require "../../spec_helper"

describe DirectoryResolver do
  let(:dr) do
    root_path : String =  File.dirname(__FILE__) + "/../../resources/example_directory" 
    DirectoryResolver.new(root_path: root_path, root_selector: "/files") 
  end
  
  let(:req) { RequestBody.new(["/"]) }

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

    it "lists .txt files as text entries" do
      result = dr.resolve(req)
      menu = result.value.as Menu

      ipsum = menu.entries.count do |entry|
        entry.entry_type == MenuEntryType::TextFile &&
          entry.selector == "/files/ipsum.txt"
      end

      expect(ipsum).must_equal(1)
    end

    it "includes submenus" do
      result = dr.resolve(req)
      menu = result.value.as Menu

      puts menu.entries
      
      submenu = menu.entries.count do |entry|
        entry.entry_type == MenuEntryType::Submenu &&
          entry.selector == "/files/games"
      end

      expect(submenu).must_equal(1)
    end
  end
end
