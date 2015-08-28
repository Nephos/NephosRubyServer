Dir[File.expand_path "app/*.rb"].each do |f|
  load(f) and puts "#{f} loaded"
end
puts

module Nephos
  module Route

    ALL = []

    # @param arg [Hash or Symbol]
    # shortcut to #{Nephos::Responder.render}
    def self.render arg
      Responder.render arg
    end

    # @param path [Array]
    # find the right route to use from the url
    def self.parse_path path, verb
      route = File.join(["/"] + path)
      return ALL.find{|e| e[:match] =~ route and e[:verb] == verb}
    end

    def self.parse_env(env, route)
      verb = env["REQUEST_METHOD"]
      from = env["REMOTE_ADDR"]
      path = route.path.split("/").select{|e|not e.to_s.empty?}
      args = Hash[route.query.to_s.split("&").map{|e| e.split("=")}]
      return {route: route, verb: verb, from: from, path: path, args: args}
    end

    def self.execute(env)
      begin
        route = URI.parse(env['REQUEST_URI'])
      rescue => err
        puts "uri err #{err.message}".red
        return render(status: 500)
      end
      parsed = parse_env(env, route)
      puts "#{parsed[:from]} [#{parsed[:verb]}] \t ---> \t #{route}"
      call = parse_path(parsed[:path], parsed[:verb])
      return render(status: 404) if call.nil?
      begin
        controller = Module.const_get(call[:controller]).new(env, parsed, call)
        return render(controller.send(call[:method]) || {status: 500})
      rescue => err
        return render(status: 500)
      end
    end

  end
end

require_relative 'load'
