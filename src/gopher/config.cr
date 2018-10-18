module Gopher
  record Config, listen_port : UInt16, listen_host : String, public_port : UInt16, public_host : String
end
