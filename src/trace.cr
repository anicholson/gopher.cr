def trace(*items)
  {% if flag?(:trace) %}
    STDERR.puts "[debug] - #{items}"
  {% end %}
  nil
end
