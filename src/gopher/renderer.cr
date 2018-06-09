require "./types"

abstract class Renderer
  abstract def render(resp : Response) : RawResponse
end
