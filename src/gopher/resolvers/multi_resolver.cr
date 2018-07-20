module Gopher
  class MultiResolver < Resolver
    getter routes
    private getter host, port, relative_root

    @routes : Array(Route)

    def initialize(@host : String, @port : UInt16, @relative_root : String = "")
      super(default_host: @host, default_port: @port)
      @routes = [] of Route
    end

    def add_resolver(path : String, resolver : Resolver, description : String = path)
      resolver.default_host = host
      resolver.default_port = port

      if resolver.is_a?(DirectoryResolver)
        absolute_root_path = [relative_root, path].join "/"
        debug "adding a DirectoryResolver, so setting relative_root to #{absolute_root_path}"
        resolver.root_selector = absolute_root_path
      end

      @routes << Route.new(path: path, resolver: resolver, description: description)
      self
    end

    def menu_entry_type
      MenuEntryType::Submenu
    end

    def resolve(req : RequestBody)
      debug "MultiResolver resolving from #{relative_root}"

      if req.root?
        debug "Handling root request"

        entries = routes.map do |route|
          resolver = route.resolver

          MenuEntry.new(entry_type: resolver.menu_entry_type, description: route.description, selector: route.path, host: host, port: port)
        end

        debug "returning a menu"
        return Response.ok(Menu.new(entries))
      end

      last_result = nil

      debug "Selector is", req.relative_selector

      route = routes.find { |route| route.match req.relative_selector }

      if route.nil?
        return Response.error("Nothing was found that matched #{req.selector}")
      end

      new_request_body = RequestBody.new(req.relative_selector.lchop(route.path))

      result = route.resolver.resolve(new_request_body)
    end
  end
end
