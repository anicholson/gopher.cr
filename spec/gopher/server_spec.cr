require "../spec_helper"

module Gopher
  class DummyStrategy
    
  end
  
  describe Server do
    let(strategy) { Gopher::DummyStrategy.new }
    let(port) { 33333_u16 }
    
    let(server) { Gopher::Server.new(port: port, strategy: strategy) }
    
    describe "#port" do
      it "listens on the provided port" do
        expect(server.port).must_equal port
      end
    end
  end
end
