require "./types"

module Gopher
  abstract class Resolver
    abstract def resolve(req : RequestBody) : Response
    abstract def menu_entry_type : MenuEntryType
  end
end
