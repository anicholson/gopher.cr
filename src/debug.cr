def debug(*items)
  {% if flag?(:trace) %}
    STDERR.puts "[debug] - #{items}"
  {% end %}
  nil
end

