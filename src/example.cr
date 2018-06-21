require "./gopher"

alias G = Gopher

server = G::Server.new

about = G::SelectorResolver.new("/", G::Resource.new("Hello from gopherland"), G::MenuEntryType::TextFile)
example_directory = G::DirectoryResolver.new(File.dirname(__FILE__) + "/../spec/resources/example_directory")

resolver = Gopher::MultiResolver.new(host: server.host, port: server.port.to_s)
resolver.add_resolver("hello", about)
resolver.add_resolver("stuff", example_directory)

server.resolver = resolver

server.listen!
