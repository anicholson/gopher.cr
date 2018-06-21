require "../../spec_helper"

module Gopher
  describe SelectorResolver do
    let(:sel) { "/about" }
    let(:resource) { Resource.new(IO::Memory.new("Hello, Gopherspace"), ResourceEncoding::Text) }
    let(:resolver) { SelectorResolver.new(selector: sel, response: resource, menu_entry_type: MenuEntryType::Info) }
    it "returns the resource when the selector matches" do
      result = resolver.resolve(RequestBody.new(sel))

      expect(result.ok?).must_equal(true)

      contents = result.value.as(Resource).content
      expect(contents).must_equal(resource.content)
    end

    it "returns an error when the selector doesn't match" do
      result = resolver.resolve(RequestBody.new("/who_dis"))

      expect(result.error?).must_equal(true)
    end
  end
end
