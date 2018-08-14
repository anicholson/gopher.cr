module Gopher
  enum ResourceEncoding
    Text
    Binary
  end

  class Resource
    def initialize(@content : IO, @encoding : ResourceEncoding)
    end

    def initialize(string)
      initialize(content: IO::Memory.new(string), encoding: ResourceEncoding::Text)
    end

    getter encoding

    def content
      debug "About to send content"
      @content.rewind
      @content
    end
  end
end
