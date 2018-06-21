module Gopher
  class SelectorResolver < Resolver
    def initialize(@selector : String, @response : ResponseBody, @menu_entry_type : MenuEntryType)
    end

    getter menu_entry_type : MenuEntryType

    def resolve(req)
      if req.selector == selector
        Response.ok(response)
      else
        Response.error("Didn't resolve #{req.selector} against #{selector}")
      end
    end

    private getter selector, response
  end
end
