require "./types"

class Parser
  def parse(raw)
    req = RequestBody.new(raw)
    Request.ok(req)
  end
end
