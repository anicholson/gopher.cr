require "./resolver"
require "./types"

class NullResolver < Resolver
  def resolve(req : Request)
    if req.error?
      Response.error(req.error)
    else
      Response.error("NullResolver always errors out")
    end
  end
end
