require "../spec_helper"


describe ::Gopher::RequestFactory do
  describe ".from" do
    describe "when request is \r\n" do
      it "returns an IndexRequest" do
        request = ::Gopher::RequestFactory.from("\r\n")

        expect(request.t).must_equal(::Gopher::Request::T::Index)
      end
    end
    
    describe "when an unknown request comes in" do
      it "returns an InvalidRequest" do
        request = ::Gopher::RequestFactory.from("SDLFKJ")
        expect(request.t).must_equal(::Gopher::Request::T::Invalid)
      end
    end
  end
end
