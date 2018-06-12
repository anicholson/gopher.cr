require "dir"
require "dir/glob"

class DirectoryResolver < Resolver
  MENUFILE = ".gophermap"

  def initialize(@root_path : String, @root_selector : String = "")
  end

  def resolve(req) : Response
    raw_entries = [] of String
    Dir.cd(root_path) do
      raw_entries = File.read(MENUFILE).split('\n')
    end

    menu = Menu.new(menu_file_entries(raw_entries))

    Response.ok(menu)
  end

  private getter root_path, root_selector

  private def qualified_selector(s)
    File.join(root_selector, s)
  end

  private def menu_file_entries(raw_entries)
    return Menu::EMPTY.entries if raw_entries.none?

    raw_entries.map do |entry|
      if entry.blank?
        nil
      else
        fields = entry.split('\t')
        entry_type_and_description = fields[0] rescue ""
        entry_type = entry_type_and_description.chars.first
        description = entry_type_and_description.lchop

        selector = fields[1] rescue ""
        host = fields[2] rescue ""
        port = fields[3] rescue ""

        MenuEntry.new(
          entry_type: MenuEntryType.from_char(entry_type),
          description: description,
          selector: qualified_selector(selector),
          host: host,
          port: port
        )
      end
    end.compact
  end
end
