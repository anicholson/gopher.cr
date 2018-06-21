require "./menu_entry"

module Gopher
  class Menu
    EMPTY = self.new

    getter entries : Array(MenuEntry)

    def initialize(@entries = [] of MenuEntry)
    end
  end
end
