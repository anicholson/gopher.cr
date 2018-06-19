module Gopher
  class Renderer
    def render(client : IO, item : Response)
      if item.error?
        render_error(client, item.error)
      end
    end

    private def render_error(client, message)
      DefaultErrorRenderer.new(message).to_s(client)
    end
  end
end
