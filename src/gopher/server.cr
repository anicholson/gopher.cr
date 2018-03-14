require "socket"
require "socket/tcp_server"
require "./request_factory"

module Gopher
  class Server
    DEFAULT_PORT = 70_u16

    getter port : UInt16
    private getter server : TCPServer

    def initialize(@host = "localhost", @port = DEFAULT_PORT)
      @server = TCPServer.new(@host, @port)
    end

    def listen!
      while client = server.accept?
        spawn handle_request(client)
      end
    end

    private def handle_request(client)
      request = ::Gopher::RequestFactory.from(client.gets)

      response = request.handle

      client.puts response
    end
  end
end
