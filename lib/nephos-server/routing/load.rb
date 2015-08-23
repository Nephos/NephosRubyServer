module Nephos
  module Route

    def self.add(what, verb)
      Nephos::Route::ALL << what.merge(verb: verb)
      puts "[#{verb}] #{what[:url]} \t ---> \t #{what[:controller]}##{what[:method]}"
    end

    def self.check!(what)
      raise InvalidRouteUrl, "Missing URL" unless what.keys.include? :url
      raise InvalidRouteController, "Missing Controller" unless what.keys.include? :controller
      raise InvalidRouteMethod, "Missing Method" unless what.keys.include? :method
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

# @param what [Hash]
def get what
  raise InvalidRoute unless what.is_a? Hash
  what[:url] = File.expand_path File.join(route_prefix, what[:url])
  Nephos::Route.check!(what)
  Nephos::Route.add(what, "GET")
end

# @param what [Hash]
def post what
  raise InvalidRoute unless what.is_a? Hash
  what[:url] = File.join(route_prefix, what[:url])
  Nephos::Route.check!(what)
  Nephos::Route.add(what, "POST")
end

# @param what [Hash]
def put what
  raise InvalidRoute unless what.is_a? Hash
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
