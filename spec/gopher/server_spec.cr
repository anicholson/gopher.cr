require "../spec_helper"

module Gopher
  describe Server do
    let(port) { 33333_u16 }

    let(server) do
      config = Gopher::Config::DEFAULT.dup
      config.listen_port = port
      Gopher::Server.new(config)
    end

    describe "#port" do
      it "listens on the provided port" do
        expect(server.port).must_equal port
      end
    end
  end
end
