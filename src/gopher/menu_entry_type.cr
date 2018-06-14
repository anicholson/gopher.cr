
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
