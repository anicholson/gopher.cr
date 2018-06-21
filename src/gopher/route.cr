module Gopher
  record Route, path : String, resolver : Resolver, description : String do
    def match(selector)
      /^#{path}.*/.match selector
    end
  end
end
