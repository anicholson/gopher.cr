require "./request"

module Gopher
  module RequestHandler
    abstract def handle(request : Request) : String
  end
end
