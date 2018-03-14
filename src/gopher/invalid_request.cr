require "./request"

module Gopher
  class InvalidRequest < Request
    def valid?
      false
    end
  end
end
