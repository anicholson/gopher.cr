module Gopher
  class SelectorResolver < Resolver
    def initialize(@selector : String, @response : ResponseBody, @menu_entry_type : MenuEntryType)
      super()
    end

    getter menu_entry_type : MenuEntryType

    def resolve(req)
      sel = req.selector.blank? ? "/" : req.selector
      if sel == selector
        Response.ok(response)
      else
        Response.error("Didn't resolve #{req.selector} against #{selector}")
      end
    end

    private getter selector, response
  end
end
