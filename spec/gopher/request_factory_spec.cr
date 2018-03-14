require "../spec_helper"

module Gopher
  module RequestHandler
    abstract def handle(request : Request)
    end

    class ErrorHandler
      include RequestHandler

      def handle( request : Request )
        nil
      end
    end
  
  class RequestFactory
    def self.from(input : String)
      from(input.to_slice)
    end
    
    def self.from(input) : Request
      request_type, handler = determine_handler(input)
      Request.new(raw: input, t: request_type, valid: false, handler: handler)
    end

    private def self.determine_handler(input)
      if input == "\r\n".to_slice
        { Request::T::Index, ErrorHandler.new }
      else
        { Request::T::Invalid, ErrorHandler.new }
      end
    end
  end
end



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
