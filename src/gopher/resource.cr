enum ResourceEncoding
  Text
  Binary
end

class Resource
  def initialize(@content : IO, @encoding : ResourceEncoding)
  end

  getter content, encoding
end
