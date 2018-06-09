require "./request"

module Gopher
  module Strategy
    abstract def to_request(input) : ::Gopher::Request
  end

  class DummyStrategy
    include Strategy

    def to_request(input)
      ::Gopher::Request.new(raw: input, valid: false, t: Request::T::Invalid, handler: InvalidHandler.new)
    end
  end
end
