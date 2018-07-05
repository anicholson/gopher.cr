module Gopher
  record Route, path : String, resolver : Resolver, description : String do
    def match(selector)
      (/^#{path}.*/.match selector).tap do |result|
        debug "#{path} match #{selector} : #{result}"
      end
    end
  end
end
