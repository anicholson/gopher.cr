require "./types"

abstract class Resolver
  abstract def resolve(req : RequestBody) : Response
end
