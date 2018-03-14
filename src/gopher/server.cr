require "socket"
require "socket/tcp_server"

module Gopher
  class Server
    DEFAULT_PORT = 70_u16
    
    getter port : UInt16

    def initialize(@host = "localhost", @port = DEFAULT_PORT)
      @server = TCPServer.new(@host, @port)
    end
  end
end
