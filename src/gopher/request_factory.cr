require "./error_handler"

module Gopher
  class IndexHandler
    include RequestHandler

    def handle(request)
      "YAS"
    end
  end

  class RequestFactory
    def self.from(input : String?)
      input = input.nil? ? "" : input.as(String)
      from(input.to_slice)
    end

    def self.from(input) : Request
      request_type, handler = determine_handler(input)
      handler = handler.as(RequestHandler)

      Request.new(raw: input, t: request_type, valid: false, handler: handler)
    end

    alias HandlerPair = Tuple(Request::T, RequestHandler)

    private def self.determine_handler(input) : HandlerPair
      if input == "\r\n".to_slice
        {Request::T::Index, IndexHandler.new}
      else
        {Request::T::Invalid, ErrorHandler.new}
      end
    end
  end
end
