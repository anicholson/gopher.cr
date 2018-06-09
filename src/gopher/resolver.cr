require "./types"

abstract class Resolver
  abstract def resolve(req : Request) : Response
end
