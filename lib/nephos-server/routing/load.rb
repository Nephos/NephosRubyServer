module Nephos
  module Route

    def self.add(what, verb)
      Nephos::Route::ALL << what.merge(verb: verb)
      display = "[#{verb}] #{what[:url]} \t ---> \t #{what[:controller]}##{what[:method]}"
      puts display unless what[:silent]
      return display
    end

    def self.add_params!(what)
      params = what[:url].split('/').map do |p|
        p.match(/:\w+/) ? {p: "[[:graph:]]+", name: p} : {p: p, name: nil}
      end
      url = params.map{|e| e[:p]}.join("/")
      url = "/" if url.empty?
      what[:match] = /^#{url}$/
      what[:params] = params.map{|e| e[:name] && e[:name][1..-1]}[1..-1] || []
    end

    def self.check_keys! what
      raise InvalidRouteUrl, "Missing URL" unless what.keys.include? :url
      raise InvalidRouteController, "Missing Controller" unless what.keys.include? :controller
      raise InvalidRouteMethod, "Missing Method" unless what.keys.include? :method
    end

    def self.check_controller! what
      begin
        controller = Module.const_get(what[:controller])
      rescue => err
        raise InvalidRouteController, "Controller \"#{what[:controller]}\" doesn't exists"
      end
      if not controller.ancestors.include? Nephos::Controller
        raise InvalidRouteController, "Class \"#{what[:controller]}\" is not a Nephos::Controller"
      end
      begin
        instance = controller.new
      rescue => err
        raise InvalidRouteController, "Cannot initialize controller"
      end
      return instance
    end

    def self.check_method! what, instance
      if not instance.respond_to? what[:method]
        raise InvalidRouteMethod, "No method named \"#{what[:method]}\""
      end
    end

    def self.check!(what)
      check_keys! what
      instance = check_controller! what
      check_method! what, instance
    end

  end
end

def route_prefix
  @route_prefix ||= []
  File.join(["/"] + @route_prefix)
end

def add_route(what, verb)
  raise InvalidRoute unless what.is_a? Hash
  what[:url] = File.expand_path File.join(route_prefix, what[:url])
  Nephos::Route.check!(what)
  Nephos::Route.add_params!(what)
  Nephos::Route.add(what, verb)
end

# @param what [Hash]
def get what
  add_route what, "GET"
end

# @param what [Hash]
def post what
  add_route what, "POST"
end

# @param what [Hash]
def put what
  add_route what, "PUT"
end

def resource(name, &block)
  @route_prefix ||= []
  @route_prefix << name
  block.call
  @route_prefix.pop
end

load 'routes.rb'
puts
