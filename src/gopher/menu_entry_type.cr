module Gopher
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

    def to_char
      {
        TextFile      => '0',
        Submenu       => '1',
        PhoneBook     => '2',
        Error         => '3',
        BinHexBinary  => '4',
        DOSBinary     => '5',
        UUEncoded     => '6',
        SearchEngine  => '7',
        TelnetSession => '8',
        Binary        => '9',
        Mirror        => '+',
        GIF           => 'g',
        Image         => 'I',
        Telnet3270    => 'T',
        HTMLFile      => 'h',
        Info          => 'i',
        SoundFile     => 's',
      }[self]
    end
  end
end
