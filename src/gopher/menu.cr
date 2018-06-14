require "./menu_entry"

class Menu
  EMPTY = self.new

  getter entries : Array(MenuEntry)

  def initialize(@entries = [] of MenuEntry)
  end
end
