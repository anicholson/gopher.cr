require "../../spec_helper"

module Gopher
  class StubResolver < Resolver
    def initialize(&custom : String -> Bool)
      @called = false
      @resolved = false
      @custom = custom
    end

    def called?
      @called
    end

    def resolved?
      @resolved
    end

    def menu_entry_type
      MenuEntryType::Submenu
    end

    def resolve(req : RequestBody)
      @called = true
      result = custom.call(req.selector)

      @resolved = result

      if result
        Response.ok(Resource.new(IO::Memory.new("I got called with #{req.selector} and resolved!"), ResourceEncoding::Text))
      else
        Response.error("I got called with #{req.selector} and didn't resolve")
      end
    end

    private getter custom
  end

  describe MultiResolver do
    let(:resolver) { MultiResolver.new("localhost", "70") }

    describe "#add_resolver" do
      it "stores the resolver" do
        expect(resolver.routes.size).must_equal(0)
        resolver.add_resolver("/home", NullResolver.new)
        expect(resolver.routes.size).must_equal(1)
      end

      it "allows multiple resolvers at a given point" do
        expect(resolver.routes.size).must_equal(0)
        resolver.add_resolver("/home", NullResolver.new)
        resolver.add_resolver("/home", NullResolver.new)
        expect(resolver.routes.size).must_equal(2)
      end
    end

    describe "#resolve" do
      let(:never_resolves) {
        StubResolver.new do |sel|
          false
        end
      }

      let(:always_resolves) {
        StubResolver.new do |sel|
          true
        end
      }

      let(:third) { StubResolver.new { |r| false } }

      before do
        resolver.add_resolver("/second", never_resolves, "S1")
        resolver.add_resolver("/second", always_resolves, "S2")
        resolver.add_resolver("/third", third)
      end

      describe "resolving /" do
        it "works" do
          result = resolver.resolve(RequestBody.new "/")

          expect(result.ok?).must_equal(true)
        end

        it "lists the subresolvers it knows about" do
          result = resolver.resolve(RequestBody.new "/").value

          expect(result.class).must_equal(Menu)
        end
      end

      it "calls resolvers until one resolves with a Result_Ok" do
        result = resolver.resolve(RequestBody.new "/second")

        expect(never_resolves.called?).must_equal(true)
        expect(always_resolves.called?).must_equal(true)
        expect(third.called?).must_equal(false)
      end

      it "returns a sensible error if nothing matches" do
        result = resolver.resolve(RequestBody.new "/funk")

        expect(never_resolves.called?).must_equal(false)
        expect(always_resolves.called?).must_equal(false)
        expect(third.called?).must_equal(false)

        expect(result.error?).must_equal(true)
      end
    end
  end
end
