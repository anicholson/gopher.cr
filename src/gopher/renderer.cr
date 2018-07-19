module Gopher
  class Renderer
    def render(client : IO, item : Response)
      trace "Rendering an item of type: #{item.class}"

      if item.error?
        return render_error(client, item.error)
      end

      if item.value.is_a?(Menu)
        return render_menu(client, item.value.as(Menu))
      end

      if item.value.is_a?(Resource)
        client << item.value.as(Resource).content
      end
    end

    private def render_error(client, message)
      DefaultErrorRenderer.new(message).to_s(client)
    end

    private def render_menu(client, item)
      trace "Rendering menu back to user: #{item.entries.size} entries"
      item.entries.each { |i| trace i }
      item.entries.each &.to_s(client)
      client << '.'
    end
  end
end
