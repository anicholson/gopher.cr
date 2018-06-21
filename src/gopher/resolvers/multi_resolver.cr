module Gopher
  class MultiResolver < Resolver
    getter routes
    private getter host, port

    @routes : Array(Route)

    def initialize(@host : String, @port : String, @relative_root : String = "")
      @routes = [] of Route
    end

    def add_resolver(path : String, resolver : Resolver, description : String = path)
      @routes << Route.new(path: path, resolver: resolver, description: description)
      self
    end

    def menu_entry_type
      MenuEntryType::Submenu
    end

    def resolve(req : RequestBody)
      if req.root?
        entries = routes.map do |route|
          resolver = route.resolver

          MenuEntry.new(entry_type: resolver.menu_entry_type, description: route.description, selector: route.path, host: host, port: port)
        end

        return Response.ok(Menu.new(entries))
      end

      last_result = nil
      routes.each do |route|
        if route.match req.selector
          result = route.resolver.resolve(req)

          return result if result.ok?

          last_result = result
        end
      end

      if last_result.nil?
        Response.error("Nothing was found that matched #{req.selector}")
      else
        last_result.as(Response)
      end
    end
  end
end
