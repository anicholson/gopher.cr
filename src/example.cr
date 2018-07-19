require "./gopher"
require "option_parser"

alias G = Gopher

server_port = 70_u16

OptionParser.parse! do |parser|
  parser.banner = "Example gopher.cr server"

  parser.on("-p PORT", "--port=PORT", "Port to run on (default: 70)") { |port| server_port = port.to_u16 }
end

server = G::Server.new port: server_port

about = G::SelectorResolver.new("/", G::Resource.new("Hello from gopherland"), G::MenuEntryType::TextFile)
example_directory = G::DirectoryResolver.new(File.dirname(__FILE__) + "/../spec/resources/example_directory")

resolver = Gopher::MultiResolver.new(host: server.host, port: server.port.to_s)
resolver.add_resolver("hello", about)
resolver.add_resolver("stuff", example_directory)

server.resolver = resolver

server.listen!
