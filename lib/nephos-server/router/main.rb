Dir[File.expand_path "app/*.rb"].each do |f|
  load(f) and puts "#{f} loaded"
end
puts

module Nephos

  # The {Router} provides an interface between the {Controller} and the client
  # queries.
  class Router

    ROUTES = []

    def initialize(opt={})
      @responder = Responder.new
      @silent = !!opt[:silent]
    end

    def render_controller req, call
      return @responder.render_from_controller(req, call)
    end

    def render_error(req, code, err=nil)
      if Nephos.env == "production"
        return @responder.render(status: code)
      elsif err
        msg = err
        if msg.is_a? Exception
          msg = err.message + "\n"
          msg += "--- Backtrace ---\n" + err.backtrace.join("\n") + "\n"
        end
        return @responder.render(status: code, content: "Error: #{code}\n#{msg}")
      else
        return @responder.render(status: code)
      end
    end

    # @param path [Array]
    #
    # Find the right route to use from the url
    def find_route req
      return ROUTES.find{|e| e[:match] =~ req.path and e[:verb] == req.request_method}
    end

    # Interface which handle the client query (stored in env), create a new
    # {Controller} instance, and call the render on it
    def execute(req)
      env = req.env
      puts "#{req.env["REMOTE_ADDR"]} [#{req.request_method}] \t ---> \t #{req.path}" unless @silent
      call = find_route(req)
      return render_error(req, 404, "404 not found \"#{req.path}\"") if call.nil?
      begin
        return render_controller(req, call)
      rescue => err
        STDERR.puts "Error: #{err.message}"
        STDERR.puts err.backtrace
        return render_error(req, 500, err)
      end
    end

  end
end

require_relative 'load'
