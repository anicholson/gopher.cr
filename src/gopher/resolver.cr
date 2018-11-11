module Gopher
  abstract class Resolver
    abstract def resolve(req : RequestBody) : Response
    abstract def menu_entry_type : MenuEntryType

    property default_host : String, default_port : UInt16

    DEFAULT_PUBLIC_HOST = "localhost"
    DEFAULT_PUBLIC_PORT = 70_u16

    def initialize(config)
      @default_host = config.public_host
      @default_port = config.public_port
    end

    def initialize(@default_host, @default_port)
    end

    def initialize
      @default_host = DEFAULT_PUBLIC_HOST
      @default_port = DEFAULT_PUBLIC_PORT
    end
  end
end
