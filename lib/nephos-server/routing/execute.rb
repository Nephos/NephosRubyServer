require_relative 'controller'

Dir[File.expand_path "controllers/*.rb"].each do |f|
  load(f) and puts "#{f} loaded"
end
puts

module Nephos
  module Route

    ALL = []

    def self.render arg
      Responder.render arg
    end

    def self.parse_path path
      route = "/" + path.join("/")
      return ALL.find{|e| e[:url] == route}
    end

    def self.execute(env)
      route = URI.parse(env['REQUEST_URI']) rescue (puts "uri err"; return render(status: 500))
      verb = env["REQUEST_METHOD"]
      from = env["REMOTE_ADDR"]
      path = route.path.split("/").select{|e|not e.to_s.empty?}
      args = Hash[route.query.to_s.split("&").map{|e| e.split("=")}]
      puts "#{from} [#{verb}] \t ---> \t #{route}"
      parsed = {route: route, verb: verb, from: from, path: path, args: args}
      call = parse_path(path)
      return render status: 404 if call.nil?
      call = parse_path(path)
      begin
        controller = Module.const_get(call[:controller]).new(env, parsed)
        return render(controller.send(call[:method]) || {status: 500})
      rescue => err
        # require 'pry'; binding.pry
        return render(status: 500)
      end
    end

  end
end

require_relative 'load'
