require "dir"
require "dir/glob"

module Gopher
  class DirectoryResolver < Resolver
    MENUFILE          = ".gophermap"
    HOST_MARKER       = "%HOST%"
    PORT_MARKER       = "%PORT%"
    IMAGE_EXTENSIONS  = [".jpg", ".gif", ".bmp", ".png", ".jpeg", ".tif", ".tiff", ".tga", ".ico"]
    BINARY_EXTENSIONS = IMAGE_EXTENSIONS + [".zip", ".tar", ".gz", ".bz2", ".doc", ".xls", ".ppt", ".exe", ".wav", ".mp3", ".ogg"]
    TEXT_EXTENSIONS   = [".c", ".C", ".cpp", ".cs", ".cr", ".d", ".el", ".fs", ".html", ".xml", ".json", ".txt", ".md", ".markdown", ".rb", ".py", ".sh", ".js", ".rtf"]

    def initialize(@root_path : String, @root_selector : String = "", @default_host : String = "localhost", @default_port : UInt16 = 70_u16)
    end

    def menu_entry_type
      MenuEntryType::Submenu
    end

    def resolve(request : RequestBody) : Response
      debug request.selector

      relative_request = RequestBody.new(request.selector.lchop(root_selector))

      if relative_request.root?
        debug "Resolving root request: "
        resolve_root
      else
        resolve_selector relative_request.selector.as(String).lchop('/')
      end
    end

    private def resolve_selector(sel)
      relative_sel = relative_selector(sel)

      debug "Resolving: #{relative_sel}"

      if is_submenu?(relative_sel)
        Dir.cd(root_path) do
          Dir.cd(relative_sel) do
            raw = File.read(MENUFILE)
            return Response.ok(menu_from_file(raw))
          end
        end
      end

      if is_file?(relative_sel)
        Dir.cd(root_path) do
          io = io_resource(relative_sel)
          encoding = guess_encoding(relative_sel)

          Response.ok(Resource.new(io, encoding))
        end
      else
        debug "Unable to resolve selector: #{relative_sel}"
        Response.error("Unable to resolve selector: #{relative_sel}")
      end
    end

    private def resolve_root : Response
      raw_contents = ""
      Dir.cd(root_path) do
        raw_contents = File.read(MENUFILE)
      end

      Response.ok(menu_from_file(raw_contents))
    end

    private def menu_from_file(contents)
      raw_entries = contents.split('\n').map do |entry|
        entry.gsub(HOST_MARKER, default_host)
          .gsub(PORT_MARKER, default_port)
      end
      Menu.new(menu_file_entries(raw_entries))
    end

    private getter root_path
    property default_host, default_port, root_selector

    private def qualified_selector(s)
      File.join(root_selector, s)
    end

    private def relative_selector(fq_selector)
      fq_selector.sub(root_selector, ".")
    end

    private def io_resource(file_path)
      File.open(file_path, "rb")
    end

    private def guess_encoding(file_path)
      extension = File.extname(file_path).downcase
      if BINARY_EXTENSIONS.includes? extension
        ResourceEncoding::Binary
      elsif TEXT_EXTENSIONS.includes? extension
        ResourceEncoding::Text
      elsif File.info(file_path).permissions.owner_execute?
        ResourceEncoding::Binary
      else
        ResourceEncoding::Binary
      end
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
          entry_type_and_description = entry_type_and_description.lchop
          description = entry_type_and_description.lchop '/'

          selector = fields[1] rescue ""
          host = fields[2] rescue Resolver::DEFAULT_HOST
          port = fields[3].to_u16 rescue Resolver::DEFAULT_PORT

          debug "found entry: #{selector}, #{host}, #{port}"

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

    private def is_file?(selector)
      debug "Checking if #{selector} is a file in #{root_path}"
      debug "File.expand_path: #{File.expand_path(selector, root_path)}"
      #      Dir.cd(root_path) do
      return File.exists?(File.expand_path(selector, root_path))
      #      end
    end

    private def is_submenu?(selector)
      Dir.cd(root_path) do
        return File.directory?(selector)
      end
    end
  end
end
