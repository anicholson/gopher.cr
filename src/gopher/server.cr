require "socket"
require "socket/tcp_server"

module Gopher
  class Server
    DEFAULT_PORT = 70_u16

    getter port : UInt16, host : String
    private getter server : TCPServer
    private getter renderer : Renderer
    property resolver : ::Gopher::Resolver

    def initialize(@resolver = NullResolver.new, @host = "localhost", @port = DEFAULT_PORT)
      @server = TCPServer.new(host: @host, port: @port, reuse_port: true)
      @renderer = Renderer.new
    end

    def listen!
      puts "listening on port #{port}"
      while client = server.accept?
        spawn handle_request(client)
      end
    end

    private def handle_request(client)
      puts "Handling request: "
      raw = client.gets || "/"

      puts raw
      request = RequestBody.new(raw.strip)
      result = resolver.resolve(request)

      renderer.render(client, result)
      end_response(client)
      client.close
    end

    private def end_response(client)
      client.write ".".encode("utf-8")
    end
  end
end
