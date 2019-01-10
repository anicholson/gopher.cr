require "dir"
require "dir/glob"

module Gopher
  class DirectoryResolver < Resolver
    MENUFILE          = ".gophermap"
    HOST_MARKER       = "%HOST%"
    PORT_MARKER       = "%PORT%"
    IMAGE_EXTENSIONS  = [".jpg", ".gif", ".bmp", ".png", ".jpeg", ".tif", ".tiff", ".tga", ".ico"]
    BINARY_EXTENSIONS = IMAGE_EXTENSIONS + [".zip", ".tar", ".gz", ".bz2", ".doc", ".xls", ".ppt", ".exe", ".wav", ".mp3", ".ogg"]
    TEXT_EXTENSIONS   = [".c", ".cpp", ".cs", ".cr", ".d", ".el", ".fs", ".html", ".xml", ".json", ".txt", ".md", ".markdown", ".rb", ".py", ".sh", ".js", ".rtf"]

    def initialize(@root_path : String, @root_selector : String, config)
      super(config)
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

    private def resolve_selector(sel, paths = [] of String)
      relative_sel = relative_selector(sel)

      debug "Resolving: #{relative_sel}"

      leaf_node = relative_sel.count('/') == 0

      if leaf_node
        relative_sel = relative_sel.lchop

        subpath = if paths.any?
                    paths.join('/')
                  else
                    "."
                  end

        if is_submenu?(relative_sel, subpath)
          Dir.cd(root_path) do
            Dir.cd(subpath) do
              Dir.cd(relative_sel) do
                raw = File.read(MENUFILE)
                return Response.ok(menu_from_file(relative_sel, raw))
              end
            end
          end
        end

        file_to_send = find_file(relative_sel, subpath)
        if file_to_send
          io = io_resource(file_to_send)
          encoding = guess_encoding(file_to_send)

          Response.ok(Resource.new(io, encoding))
        else
          debug "Unable to resolve selector: #{relative_sel}"
          Response.error("Unable to resolve selector: #{relative_sel}")
        end
      else
        tree = relative_sel.split('/', 2)

        next_node = tree.first.lchop

        debug "Next node: #{next_node}"

        if File.directory?([root_path, next_node].join('/'))
          debug "Going to descend"
          resolve_selector(tree[1].lchop('/'), paths << next_node)
        else
          debug "#{next_node} is not a dir"
          raise "BOOM"
        end
      end
    end

    private def resolve_root : Response
      raw_contents = ""
      Dir.cd(root_path) do
        raw_contents = File.read(MENUFILE)
      end

      Response.ok(menu_from_file("/", raw_contents))
    end

    private def menu_from_file(relative_root, contents)
      raw_entries = contents.split('\n').map do |entry|
        entry.gsub(HOST_MARKER, default_host)
          .gsub(PORT_MARKER, default_port)
      end
      Menu.new(menu_file_entries(relative_root, raw_entries))
    end

    private getter root_path
    property default_host, default_port, root_selector

    private def qualified_selector(relative_root, s)
      File.join(root_selector, relative_root, s)
    end

    private def relative_selector(fq_selector)
      fq_selector.sub(root_selector, ".").rchop('/')
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

    private def menu_file_entries(relative_root, raw_entries)
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
          host = fields[2] rescue Resolver::DEFAULT_PUBLIC_HOST
          port = fields[3].to_u16 rescue Resolver::DEFAULT_PUBLIC_PORT

          debug "found entry: #{selector}, #{host}, #{port}"

          MenuEntry.new(
            entry_type: MenuEntryType.from_char(entry_type),
            description: description,
            selector: qualified_selector(relative_root, selector),
            host: host,
            port: port
          )
        end
      end.compact
    end

    private def find_file(selector, subpath = "")
      fully_qualified_search_path = File.expand_path(File.join(root_path, subpath, selector), root_path)
      debug "Checking if #{selector} is a file in #{root_path}/#{subpath}"
      debug "File.expand_path: #{fully_qualified_search_path}"

      if File.exists?(fully_qualified_search_path)
        fully_qualified_search_path
      else
        nil
      end
    end

    private def is_submenu?(selector, subpath)
      search_path = File.expand_path(File.join(root_path, subpath), root_path)

      debug "Checking if #{selector} is a directory in #{search_path}"

      Dir.cd(search_path) do
        return File.directory?(selector)
      end
    end
  end
end
