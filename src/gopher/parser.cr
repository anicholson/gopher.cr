require "./types"

abstract class Parser
  abstract def parse(raw : RawRequest) : Request
end
