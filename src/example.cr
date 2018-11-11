require "./gopher"
require "option_parser"

# :nodoc:
alias G = Gopher

config = G::Config.new listen_port: 70_u16, listen_host: "0.0.0.0", public_port: 70_u16, public_host: "0.0.0.0"

OptionParser.parse! do |parser|
  parser.banner = "Example gopher.cr server"

  parser.on("-p LISTEN_PORT", "--port=LISTEN_PORT", "Port to listen on (default: 70)") { |port| config.listen_port = port.to_u16 }
  parser.on("-H PUBLIC_HOST", "--public-host=PUBLIC_HOST", "FQ name of the server (default: localhost)") { |hostname| config.public_host = hostname }
  parser.on("-o PUBLIC_PORT", "--public-port=PUBLIC_PORT", "Public port to pass to clients. (Useful if server lives behind a gateway)") { |public_port| config.public_port = public_port.to_u16 }
  parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }
end

server = G::Server.new config

about = G::SelectorResolver.new("/", G::Resource.new("Hello from gopherland"), G::MenuEntryType::TextFile)
example_directory = G::DirectoryResolver.new(File.dirname(__FILE__) + "/../spec/resources/example_directory", "", config)

resolver = Gopher::MultiResolver.new("", config)
resolver.add_resolver("hello", about)
resolver.add_resolver("stuff", example_directory)

server.resolver = resolver

server.listen!
