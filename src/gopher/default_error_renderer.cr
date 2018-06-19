require "ecr"
require "ecr/macros"

module Gopher
  class DefaultErrorRenderer
    def initialize(@message : String)
    end

    def to_s(io)
      puts "to_s called"
      ECR.embed("src/gopher/default_error_message.ecr", io)
    end
  end
end
