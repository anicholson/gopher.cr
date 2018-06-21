module Gopher
  class NullResolver < Resolver
    def resolve(req : RequestBody)
      Response.error("NullResolver always errors out")
    end

    def menu_entry_type : MenuEntryType
      MenuEntryType::Error
    end
  end
end
