Dir[File.expand_path "app/*.rb"].each do |f|
  load(f) and puts "#{f} loaded"
end
puts

module Nephos

  # The {Router} provides an interface between the {Controller} and the client
  # queries.
  class Router

    ROUTES = []

    # @param opt [Hash] it contains optional parameters, via the keys (Symbol only)
    #   - :silent : if true, then there will be no puts on the stdin when a request is routed.
    #     Else, or by default, there will be information printed on stdin
    def initialize(opt={})
      @responder = Responder.new
      @silent = !!opt[:silent]
    end

    # render the return of a call to Controller.new.method.
    # Controller and method are stored on call via the keys :controller and :method
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

    def error_custom(req, code, default=nil)
      if File.exists? "app/#{code}.html"
        @responder.render(status: code, html: File.read("app/#{code}.html"))
      else
        render_error(req, code, default || "Error: #{req.status}")
      end
    end

    def error_404(req)
      out = error_custom(req, 404, "404 not found \"#{req.path}\"")
      out.body[0].gsub!("INJECT_REQ_PATH", req.path)
      return out
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
      # require 'pry'
      # binding.pry
      return error_404(req) if call.nil?
      begin
        return render_controller(req, call)
      rescue => err
        STDERR.puts "Error: #{err.message}" unless @silent
        STDERR.puts err.backtrace unless @silent
        return error_custom(req, 500, "#{err.message}\n---Backtrace---\n#{err.backtrace.join("\n")}\n")
      end
    end

  end
end

require_relative 'load'
