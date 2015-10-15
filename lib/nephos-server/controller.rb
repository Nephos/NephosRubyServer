module Nephos

  # This class must be inherited by the other Controllers.
  # It contains a constructor (you should not rewrite it)
  # It contains some helpers too, like an access to the environment,
  # and the parameters.
  class Controller

    attr_reader :req, :callpath, :params, :cookies, :extension
    alias :format :extension

    # @param env [Hash] env extracted from the http request
    # @param parsed [Hash] pre-parsed env with parameters, ...
    # @param extension [String] extension ".json", ".html", ...
    def initialize req, callpath, extension=nil
      raise ArgumentError, "req must be a Rack::Request" unless req.is_a? Rack::Request
      raise ArgumentError, "call must be a Hash" unless callpath.is_a? Hash
      @req= req
      @callpath= callpath
      @params= req.params rescue {}

      params = @req.path.split("/")
      params.shift
      @params.merge! Hash[callpath[:params].zip(params)]
      @params.select!{|k,v| not k.to_s.empty?}

      @params = Params.new(@params)
      @cookies = Params.new(@req.cookies)

      @extension = extension.to_s.split(".").last
    end

    def html?
      %w(htm html xhtml).include? extension
    end
    def json?
      %w(json).include? extension
    end
    def plain?
      %w(txt raw).include? extension
    end

    # @return [String] an url formated as "scheme://host:port/path"
    def url_for(path="")
      (URI(req.env["rack.url_scheme"] + "://" + req.env['HTTP_HOST'] + "/") + path).to_s
    end

    @@before_action = {:'*' =>  []}
    @@after_action = {:'*' =>  []}

    def self.parse_action_opts(opt)
      if opt.nil?
        if block_given? then yield :'*' else return [:'*'] end
      elsif opt.is_a? Hash
        only = Array(opt[:only])
        if block_given? then only.each{|e| yield e} else return only end
        except = opt[:except]
        raise "No implemented yet (except)" if except
        # parse :only and :except
      elsif opt.is_a? String or opt.is_a? Symbol
        if block_given? then yield opt else return [opt] end
      else
        raise ArgumentError, "Invalid opt"
      end
    end

    # @param method [Symbol]
    # @param opt [Nil, Hash, String, Symbol] define which method will call "method"
    #   - if nil, then all call will trigger the event
    #   - if Hash, it will be parsed with rules :only and :except
    #   - if String or Symbol, it will be parsed as :only
    def self.before_action(method, opt=nil)
      parse_action_opts(opt) do |call|
        @@before_action[call] ||= []
        @@before_action[call] << method.to_sym
      end
    end

    # see {#self.before_action}
    def self.after_action(method, opt=nil)
      parse_action_opts(opt) do |call|
        @@after_action[call] ||= []
        @@after_action[call] << method.to_sym
      end
    end

    # It calls every registred hooks added to the @before_action list,
    # including '*'
    def execute_before_action(call)
      call = call.to_sym
      methods = []
      methods += Array(@@before_action[call])
      methods += @@before_action[:'*']
      methods.each do |method|
        self.send(method)
      end
    end

    # see {#self.execute_before_action}
    def execute_after_action(call)
      call = call.to_sym
      methods = []
      methods += Array(@@after_action[call])
      methods += @@after_action[:'*']
      methods.each do |method|
        self.send(method)
      end
    end

  end
end
