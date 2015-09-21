Dir[File.expand_path "app/*.rb"].each do |f|
  load(f) and puts "#{f} loaded"
end
puts

module Nephos

  # The {Router} provides an interface between the {Controller} and the client
  # queries.
  module Router

    ROUTES = []

    # @param arg [Hash or Symbol]
    #
    # Shortcut to #{Nephos::Responder.render}
    def self.render arg
      Responder.render arg
    end

    # @param path [Array]
    #
    # Find the right route to use from the url
    def self.parse_path path, verb
      route = File.join(["/"] + path)
      return ROUTES.find{|e| e[:match] =~ route and e[:verb] == verb}
    end

    def self.parse_env(env, route)
      verb = env["REQUEST_METHOD"]
      from = env["REMOTE_ADDR"]
      path = route.path.split("/").select{|e|not e.to_s.empty?}
      params = Rack::Request.new(env).params
      # Hash[route.query.to_s.split("&").map{|e| e.split("=")}]
      return {route: route, verb: verb, from: from, path: path, params: params}
    end

    def self.error(code, err=nil)
      if ENV["ENVIRONMENT"].to_s.match(/prod(uction)?/)
        return render(status: code)
      elsif err
        #TODO: improve this
        return render(status: code, content: "Error: #{code}\n" + (err.is_a?(String) ? err : err.message))
      else
        return render(status: code)
      end
    end

    # Interface which handle the client query (stored in env), calls the
    # {Controller} method (using the routes) and render it's return
    def self.execute(env)
      begin
        route = URI.parse(env['REQUEST_URI'])
      rescue => err
        puts "uri err #{err.message}".red
        return error(500, err)
      end
      parsed = parse_env(env, route)
      puts "#{parsed[:from]} [#{parsed[:verb]}] \t ---> \t #{route}"
      call = parse_path(parsed[:path], parsed[:verb])
      return error(404, "404 not found \"#{route}\"") if call.nil?
      begin
        controller = Module.const_get(call[:controller]).new(env, parsed, call)
        return render(controller.send(call[:method]))
      rescue => err
        return error(500, err)
      end
    end

  end
end

require_relative 'load'
