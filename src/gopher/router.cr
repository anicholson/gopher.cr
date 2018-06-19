module Gopher
  class Router
    getter routes

    @routes : Array(Route)

    def initialize
      @routes = [] of Route
    end

    def add_resolver(path : String, resolver : Resolver)
      @routes << Route.new(path: /^(#{path}).*/, resolver: resolver)
    end

    def handle_request(req : RequestBody)
      last_result = nil
      routes.each do |route|
        if req.selector.match route.path
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
