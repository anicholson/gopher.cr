module Gopher
  # All the network-related config required for the Gopher server to behave properly
  # when behind NAT, Network Gateways & Docker containers.
  #
  # While Gopher's assigned port is 70, it mightn't always be possible to bind to that exact port
  # (for example, if the running user doesn't have elevated privileges).
  # Alternatively, the server may not be running on a host with the same fully-qualified domain/hostname
  # as its publicly-facing address.
  #
  # To cope with this flexibility, we accept different values from the internal & external perspectives
  # to the server.
  #
  # ## Example
  #
  # Running on a server where port 70 is not available, using port forwarding to route public requests to the app.
  # ```
  # Config.new
  #   listen_port: 7070_u16,
  #   listen_host: "localhost",
  #   public_host: "gopher.example.org",
  #   public_port: 70_u16
  # ```
  struct Config
    property listen_port : UInt16, listen_host : String, public_port : UInt16, public_host : String

    def initialize(@listen_port, @listen_host, @public_port, @public_host)
    end

    # A sane set of default config values.
    DEFAULT = new(listen_port: 70_u16, public_port: 70_u16, listen_host: "localhost", public_host: "localhost")
  end
end
