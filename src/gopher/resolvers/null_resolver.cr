class NullResolver < Resolver
  def resolve(req : RequestBody)
    Response.error("NullResolver always errors out")
  end
end
