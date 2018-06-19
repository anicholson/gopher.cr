require "socket"
require "socket/tcp_server"
require "./request_factory"

module Gopher
  class Server
    DEFAULT_PORT = 70_u16

    getter port : UInt16
    private getter server : TCPServer
    private getter router : Router

    def initialize(@host = "localhost", @port = DEFAULT_PORT, @router = Router.new)
      @server = TCPServer.new(host: @host, port: @port, reuse_port: true)
    end

    def listen!
      while client = server.accept?
        spawn handle_request(client)
      end
    end

    def add_resolver(path : String, resolver : Resolver)
      router.add_resolver(path, resolver)
    end

    private def handle_request(client)
      # request = strategy.to_request(client.gets)

      # response = request.handle

      # client.puts response
    end
  end
end
