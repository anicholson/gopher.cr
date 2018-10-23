module Gopher
  class DefaultErrorRenderer
    def initialize(@message : String)
    end

    def to_s(io)
      io << "i  ______ _____  _____   ____  _____         __  " << "\n"
      io << "i |  ____|  __ \|  __ \ / __ \|  __ \   _   / /  " << "\n"
      io << "i | |__  | |__) | |__) | |  | | |__) | (_) | |   " << "\n"
      io << "i |  __| |  _  /|  _  /| |  | |  _  /      | |   " << "\n"
      io << "i | |____| | \ \| | \ \| |__| | | \ \   _  | |   " << "\n"
      io << "i |______|_|  \_|_|  \_\\____/|_|  \_\ (_) | |   " << "\n"
      io << "i                                           \_\  " << "\n"
      io << "i                                                " << "\n"
      io << "i                                                " << "\n"
      io << "iOh dear, something went wrong with your request." << "\n"
      io << "i                                                " << "\n"
      io << "iHere's what we know:                            " << "\n"
      io << "i                                                " << "\n"
      io << "3#{@message}                                     " << "\n"
      io << "i                                                " << "\n"
      io << "iPlease let the site administrator know.         " << "\n"
    end
  end
end
