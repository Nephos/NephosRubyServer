require_relative 'responder'

module Nephos
  class Server

    attr_accessor :port, :host

    # @param port [Integer] port to listen
    def initialize port="8080", host="0.0.0.0"
      @port = Integer(port)
      @host = host.to_s
      @server = lambda {|env|
        return @router.execute(Rack::Request.new(env))
      }
    end

    # start the Rack server
    def start
      @router = Router.new
      Rack::Server.start :app => @server, :Port => @port, :Host => @host
    end

    # start the Rack server on a instance of Nephos::Server
    def self.start port, host
      Server.new(port, host).start
    end

  end
end
