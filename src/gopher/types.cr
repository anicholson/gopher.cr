require "result/result"

struct RequestBody
  def initialize(@selectors : Array(String))
  end

  getter selectors
end

enum MenuEntryType
  TextFile
  Submenu
  PhoneBook
  Error
  BinHexBinary
  DOSBinary
  UUEncoded
  SearchEngine
  TelnetSession
  Binary
  Mirror
  GIF
  Image
  Telnet3270
  HTMLFile
  Info
  SoundFile

  def self.from_char(c : Char)
    {
      '0' => TextFile,
      '1' => Submenu,
      '2' => PhoneBook,
      '3' => Error,
      '4' => BinHexBinary,
      '5' => DOSBinary,
      '6' => UUEncoded,
      '7' => SearchEngine,
      '8' => TelnetSession,
      '9' => Binary,
      '+' => Mirror,
      'g' => GIF,
      'I' => Image,
      'T' => Telnet3270,
      'h' => HTMLFile,
      'i' => Info,
      's' => SoundFile,
    }[c]
  end
end

record MenuEntry, entry_type : MenuEntryType, description : String, selector : String, host : String, port : String

class Menu
  EMPTY = self.new

  getter entries : Array(MenuEntry)

  def initialize(@entries = [] of MenuEntry)
  end
end

class Entry
end

class Error
end

alias ResponseBody = Menu | Entry | Error

alias RawRequest = String
alias RawResponse = String

alias Request = Result(RequestBody, String)
alias Response = Result(ResponseBody, String)
