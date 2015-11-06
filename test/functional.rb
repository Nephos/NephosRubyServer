require "test/unit"

require_relative "../lib/nephos-server"

# tests global
require_relative 'functional/global'
require_relative 'functional/server'

# tests on master classes
require_relative 'functional/controller'
require_relative 'functional/router'

# test global with internet required
require_relative 'functional/generator' if ARGV[0] == "internet"
