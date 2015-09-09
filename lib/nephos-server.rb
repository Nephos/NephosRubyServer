# coding: utf-8

# require 'yaml'
require 'json'
require 'open-uri'
require 'rack'
require 'colorize'

# lib
require_relative 'nephos-server/basic_errors'
require_relative 'nephos-server/params'
require_relative 'nephos-server/controller'
require_relative 'nephos-server/router/main'
# server
require_relative 'nephos-server/server/main'

module Nephos
  VERSION_FILE = __FILE__.split("/")[0..-3].join("/") + "/version"
  VERSION = File.read(VERSION_FILE).strip

  @@env = $server_env
  def self.env
    @@env
  end
end
