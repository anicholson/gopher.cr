module Gopher
  class Renderer
    def render(client : IO, item : Response)
      if item.error?
        return render_error(client, item.error)
      end

      if item.value.is_a?(Menu)
        return render_menu(client, item.value.as(Menu))
      end
    end

    private def render_error(client, message)
      DefaultErrorRenderer.new(message).to_s(client)
    end

    private def render_menu(client, item)
      item.entries.each &.to_s(client)
      client << '.'
    end
  end
end
