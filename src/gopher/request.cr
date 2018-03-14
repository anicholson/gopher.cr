module Gopher
  module RequestHandler; end
  
  class Request
    enum T
      Index
      Invalid
    end

    getter t : T, raw : Bytes, handler : RequestHandler

    def valid?
      @valid
    end
    
    def initialize(@raw : Bytes, @valid : Bool, @t : T, @handler : RequestHandler)
    end

    def handle
      handler.handle(self)
    end
  end
end
