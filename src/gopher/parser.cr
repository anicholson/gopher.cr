require "./types"

RESOURCE_TYPES = {
  '0' => "Text file",
  '1' => "Submenu",
  '2' => "CCSO Nameserver",
  '3' => "Error code",
  '4' => "BinHex-encoded file",
  '5' => "DOS file",
  '6' => "uuencoded file",
  '7' => "Full-text search",
  '8' => "Telnet",
  '9' => "Binary file",
  '+' => "Mirror or alternate server",
  'g' => "GIF",
  'I' => "Image",
  'T' => "Telnet 3270",

  # non-canonical
  'h' => "HTML file",
  'i' => "informational message",
  's' => "Sound file",
}

abstract class Parser
  abstract def parse(raw : RawRequest) : Request
end

class StandardParser < Parser
  def parse(raw)
    req = RequestBody.new(raw.split('/'))
    Request.ok(req)
  end
end
