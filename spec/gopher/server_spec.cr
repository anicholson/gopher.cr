require "../spec_helper"

module Gopher
  describe Server do
    describe "#port" do
      it "listens on the provided port" do
        port = 7070_u16
        expect(Gopher::Server.new(port: port).port).must_equal port
      end
    end


  end
end
