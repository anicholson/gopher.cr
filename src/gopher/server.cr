require "socket"
require "socket/tcp_server"

module Gopher
  # This class handles all network-related plumbing.
  # It owns the network connections, and passes the request
  # & responses around.
  class Server
    # The TCP port the server will listen on
    getter port : UInt16

    # The hostname that clients will connect to.
    getter host : String

    # The resolver that turns a request into content.
    property resolver : ::Gopher::Resolver

    def initialize(config)
      @resolver = NullResolver.new
      @host = config.listen_host
      @port = config.listen_port
    end

    def initialize(resolver, config)
      @resolver = resolver
      @host = config.listen_host
      @port = config.listen_port
    end

    # Opens a connection & starts listening for requests.
    # Each request is handled in its own fiber.
    def listen!
      puts "Gopher: listening on host #{host}, port #{port}"
      server = TCPServer.new(host: @host, port: @port, reuse_port: true)
      renderer = Renderer.new
      while client = server.accept?
        spawn handle_request(client, renderer)
      end
    end

    private def handle_request(client, renderer)
      raw = client.gets.to_s.strip

      if raw.blank? || raw == "$"
        raw = "/"
      end

      debug "Handling request: ", raw

      request = RequestBody.new(raw.strip)
      result = resolver.resolve(request)

      renderer.render(client, result)
      client.flush
      client.close
    end
  end
end
