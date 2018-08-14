module Gopher
  class Renderer
    def render(client : IO, item : Response)
      debug "Rendering an item of type: #{item.class}"

      if item.error?
        return render_error(client, item.error)
      end

      if item.value.is_a?(Menu)
        return render_menu(client, item.value.as(Menu))
      end

      if item.value.is_a?(Resource)
        client << item.value.as(Resource).content.gets_to_end
      end
    end

    private def render_error(client, message)
      DefaultErrorRenderer.new(message).to_s(client)
    end

    private def render_menu(client, item)
      debug "Rendering menu back to user: #{item.entries.size} entries"
      item.entries.each { |i| debug i }
      item.entries.each &.to_s(client)
      client << '.'
    end
  end
end
