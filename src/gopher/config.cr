module Gopher
  struct Config
    property listen_port : UInt16, listen_host : String, public_port : UInt16, public_host : String

    def initialize(@listen_port, @listen_host, @public_port, @public_host)
    end

    DEFAULT = new(listen_port: 70_u16, public_port: 70_u16, listen_host: "localhost", public_host: "localhost")
  end
end
