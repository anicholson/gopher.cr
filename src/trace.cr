module Trace
  enum Level
    Debug
    Info
    Warn
    Error
  end

  @@default_level : Level = :error

  def self.default_level=(level : Level)
    @@default_level = level
  end

  def self.default_level
    @@default_level
  end
end

macro trace_level(name)
  def {{name.id}}(*items)
    trace("{{name.id}}", *items)
  end
end

def trace(level = :info, *items)
  {% if flag?(:trace) %}
    STDERR.puts "[#{level}] - #{items}" if Trace::Level.parse(level) >= Trace.default_level
  {% end %}
  nil
end

trace_level info
trace_level debug
trace_level warn
trace_level error
