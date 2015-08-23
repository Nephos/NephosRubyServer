class RoutingError < Exception; end
class InvalidRoute < RoutingError; end
class InvalidRouteUrl < InvalidRoute; end
class InvalidRouteController < InvalidRoute; end
class InvalidRouteMethod < InvalidRoute; end

module Nephos
  module Route

    def self.add(what, verb)
      Nephos::Route::ALL << what.merge(verb: verb)
      puts "[#{verb}] #{what[:url]} \t ---> \t #{what[:controller]}##{what[:method]}"
    end

    def self.check!(what)
      raise InvalidRouteUrl if not what.keys.include? :url
      raise InvalidRouteController if not what.keys.include? :controller
      raise InvalidRouteMethod if not what.keys.include? :method
      begin
        controller = Module.const_get(what[:controller])
      rescue
        raise InvalidRouteController, "Controller \"#{what[:controller]}\" doesn't exists"
      end
      if not controller.ancestors.include? Nephos::Controller
        raise InvalidRouteController, "Class \"#{what[:controller]}\" is not a Nephos::Controller"
      end
      if not controller.new({}, {}).respond_to? what[:method]
        raise InvalidRouteMethod, "No method named \"#{what[:method]}\""
      end rescue raise InvalidRouteController, "Cannot initialize controller"
    end

  end
end

def route_prefix
  @route_prefix ||= []
  File.join(["/"] + @route_prefix)
end

# @params what [Hash]
def get what
  what[:url] = File.expand_path File.join(route_prefix, what[:url])
  Nephos::Route.check!(what)
  Nephos::Route.add(what, "GET")
end

# @params what [Hash]
def post what
  what[:url] = File.join(route_prefix, what[:url])
  Nephos::Route.check!(what)
  Nephos::Route.add(what, "POST")
end

# @params what [Hash]
def put what
  what[:url] = File.join(route_prefix, what[:url])
  Nephos::Route.check!(what)
  Nephos::Route.add(what, "PUT")
end

def resource(name, &block)
  @route_prefix ||= []
  @route_prefix << name
  block.call
  @route_prefix.pop
end

load 'routes.rb'
puts
