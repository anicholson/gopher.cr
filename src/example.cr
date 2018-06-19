require "./gopher"

alias G = Gopher

server = G::Server.new

about = G::SelectorResolver.new("/", G::Resource.new("Hello from gopherland"))

resolver = Gopher::MultiResolver.new
resolver.add_resolver("/hello", about)

server.resolver = resolver

server.listen!
