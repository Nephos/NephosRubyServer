require_relative 'responder'

module Nephos
  class Server

    SERVER = lambda {|env| return Router.execute(env)}

    attr_accessor :port

    # @param port [Integer] port to listen
    def initialize port
      @port = Integer(port)
    end

    # start the Rack server
    def start
      Rack::Server.start :app => SERVER, :Port => @port
    end

    # start the Rack server on a instance of Nephos::Server
    def self.start port
      Server.new(port).start
    end

  end
end
