require "../spec_helper"

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

  describe Router do
    let(:router) { Router.new }

    describe "#add_resolver" do
      it "stores the resolver" do
        expect(router.routes.size).must_equal(0)
        router.add_resolver("/home", NullResolver.new)
        expect(router.routes.size).must_equal(1)
      end

      it "allows multiple resolvers at a given point" do
        expect(router.routes.size).must_equal(0)
        router.add_resolver("/home", NullResolver.new)
        router.add_resolver("/home", NullResolver.new)
        expect(router.routes.size).must_equal(2)
      end
    end

    describe "handle_request" do
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
        router.add_resolver("/second", never_resolves)
        router.add_resolver("/second", always_resolves)
        router.add_resolver("/third", third)
      end

      it "calls resolvers until one resolves with a Result_Ok" do
        result = router.handle_request(RequestBody.new "/second")

        expect(never_resolves.called?).must_equal(true)
        expect(always_resolves.called?).must_equal(true)
        expect(third.called?).must_equal(false)
      end

      it "returns a sensible error if nothing matches" do
        result = router.handle_request(RequestBody.new "/funk")

        expect(never_resolves.called?).must_equal(false)
        expect(always_resolves.called?).must_equal(false)
        expect(third.called?).must_equal(false)

        expect(result.error?).must_equal(true)
      end
    end
  end
end
