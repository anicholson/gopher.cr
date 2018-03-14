require "./request"

module Gopher
  module RequestHandler
    abstract def handle(request : Request)
  end
end
