require "socket"
require "socket/tcp_server"

module Gopher
  class Server
    DEFAULT_PORT = 70_u16

    getter port : UInt16
    private getter server : TCPServer
    private property resolver : Resolver

    def initialize(@resolver = NullResolver.new, @host = "localhost", @port = DEFAULT_PORT)
      @server = TCPServer.new(host: @host, port: @port, reuse_port: true)
    end

    def listen!
      while client = server.accept?
        spawn handle_request(client)
      end
    end

    private def handle_request(client)
      # request = strategy.to_request(client.gets)

      # response = request.handle

      # client.puts response
    end
  end
end
