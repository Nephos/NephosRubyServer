# coding: utf-8

# require 'yaml'
require 'json'
require 'open-uri'
require 'rack'
require 'colorize'

require_relative 'nephos-server/version'

# lib
require_relative 'nephos-server/basic_errors'
require_relative 'nephos-server/params'
require_relative 'nephos-server/controller'
require_relative 'nephos-server/router/main'
# server
require_relative 'nephos-server/server/main'
