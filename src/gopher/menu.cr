require "./menu_entry"

module Gopher
  # Wraper object for MenuEntry items.
  class Menu
    # The canonical empty Menu.
    EMPTY = self.new

    getter entries : Array(MenuEntry)

    def initialize(@entries = [] of MenuEntry)
    end
  end
end
