module Nephos

  class Router

    def self.add(what, verb)
      Nephos::Router::ROUTES << what.merge(verb: verb)
      display = "[#{verb}] #{what[:url]} \t ---> \t #{what[:controller]}##{what[:method]}"
      puts display unless what[:silent]
      return display
    end

    # @param what [Hash]
    def self.add_params!(what)
      params = what[:url].split('/').map do |p|
        p.match(/:\w+/) ? {p: "[^\/]+", name: p} : {p: p, name: nil}
      end
      url = params.map{|e| e[:p]}.join("/+")
      url = "/" if url.empty?
      what[:match] = what[:postfix] != false ? /^(?<url>#{url})(?<extension>\.\w+)?\/*$/ : /^(?<url>#{url})\/*$/
      # remove : in :param, and / in /param
      what[:params] = params.map{|e| e[:name] && e[:name][1..-1]}[1..-1] || []
    end

    # @param what [Hash]
    #
    # Check if the what parameter contains the needed keys
    # - :url
    # - :controller
    # - :method
    def self.check_keys! what
      raise InvalidRouteUrl, "Missing URL" unless what.keys.include? :url
      if what.keys.include? :to
        match = what[:to].match(/(?<controller>\w+)\#(?<method>\w+)/)
        raise InvalidRouteTo, "Invalid Controller#Method" unless match
        what[:controller] = match["controller"]
        what[:method] = match["method"]
        what.delete :to
      else
        raise InvalidRouteController, "Missing Controller" unless what.keys.include? :controller
        raise InvalidRouteMethod, "Missing Method" unless what.keys.include? :method
      end
    end

    # @param what [Hash]
    #
    # Check if:
    # - the what parameter contains a :controller
    # - this controller exists
    # - if the controller is a child of the {Controller} class
    # - if the controller is instanciable
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
        instance = controller.new(Rack::Request.new({}), {params: []})
      rescue => err
        raise InvalidRouteController, "Cannot initialize controller"
      end
      return instance
    end

    # @param what [Hash]
    # @param instance [Controller]
    #
    # Check if the param instance has a method named what[:method]
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

require_relative 'helpers'
load 'routes.rb'
puts
