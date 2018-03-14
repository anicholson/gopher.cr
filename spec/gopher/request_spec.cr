require "../spec_helper"

describe ::Gopher::Request do
  class Nothing
    include RequestHandler

    def handle(input)
      nil
    end
  end
    let(request) { ::Gopher::Request.new(valid: false, raw: "FOO".to_slice, t: ::Gopher::Request::T::Invalid, handler: Nothing.new) }

    it "reports its as validity" do
      expect(request.valid?).must_equal(false)
    end

    it "can return its raw form" do
      expect(request.raw).must_equal(Slice[70_u8, 79_u8, 79_u8])
    end
end

