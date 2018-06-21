require "./menu_entry_type"

module Gopher
  record MenuEntry, entry_type : MenuEntryType, description : String, selector : String, host : String, port : String do
    DELIMITER = '\t'
    EOL       = "\r\n"

    def to_s(io)
      io << self.entry_type.to_char
      io << self.description
      io << DELIMITER
      io << self.selector
      io << DELIMITER
      io << self.host
      io << DELIMITER
      io << self.port
      io << EOL
    end
  end
end
