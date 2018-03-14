require "./request_handler"

module Gopher
  class ErrorHandler
    include ::Gopher::RequestHandler

    def handle(request : Request) : String
      "ERROR"
    end
  end
end
