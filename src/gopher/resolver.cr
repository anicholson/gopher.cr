require "./types"

module Gopher
  abstract class Resolver
    abstract def resolve(req : RequestBody) : Response
  end
end
