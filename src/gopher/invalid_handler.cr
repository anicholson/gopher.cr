require "./request_handler"

module Gopher
  class InvalidHandler
    include RequestHandler

    def handle(input)
      "ERROR: Invalid request"
    end
  end
end
