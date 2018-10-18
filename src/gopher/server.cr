require "socket"
require "socket/tcp_server"

module Gopher
  class Server
    DEFAULT_PORT = 70_u16

    getter port : UInt16, host : String
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
