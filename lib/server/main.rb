#coding: utf-8

# require 'json'
# require 'yaml'
require 'open-uri'
require 'rack'

require_relative 'responder'
require_relative '../routing/execute'

module Nephos
  class Server

    SERVER = lambda {|env| return Route.execute(env)}

    def initialize port
      @port = port
    end

    def start
      Rack::Server.start :app => SERVER, :Port => @port
    end

    def self.start port
      Server.new(port).start
    end

  end
end
