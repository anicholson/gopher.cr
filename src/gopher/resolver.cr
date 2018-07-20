require "./types"

module Gopher
  abstract class Resolver
    abstract def resolve(req : RequestBody) : Response
    abstract def menu_entry_type : MenuEntryType

    property default_host : String, default_port : UInt16

    DEFAULT_HOST = "localhost"
    DEFAULT_PORT = 70_u16

    def initialize(@default_host = DEFAULT_HOST, @default_port = DEFAULT_PORT)
    end
  end
end
