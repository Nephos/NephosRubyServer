module Nephos

  # This class must be inherited by the other Controllers.
  # It contains a constructor (you should not rewrite it)
  # It contains some helpers too, like an access to the environment,
  # and the parameters.
  class Controller

    attr_reader :req, :callpath, :params, :cookies

    # @param env [Hash] env extracted from the http request
    # @param parsed [Hash] pre-parsed env with parameters, ...
    def initialize req, callpath
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
    end

    @@before_action = {:'*' =>  []}
    @@after_action = {:'*' =>  []}

    def self.parse_action_opts(opt)
      if opt.nil?
        return :'*'
      elsif opt.is_a? Hash
        raise "No implemented yet"
        # parse :only and :except
      elsif opt.is_a? String or opt.is_a? Symbol
        return opt.to_sym
      else
        raise ArgumentError, "Invalid opts"
      end
    end

    # @param method [Symbol]
    # @param opt [Nil, Hash, String, Symbol] define which method will call "method"
    #   - if nil, then all call will trigger the event
    #   - if Hash, it will be parsed with rules :only and :except
    #   - if String or Symbol, it will be parsed as :only
    def self.before_action(method, opt=nil)
      call = parse_action_opts(opt)
      @@before_action[call] ||= []
      @@before_action[call] << method.to_sym
    end

    # see {#self.before_action}
    def self.after_action(method, opt=nil)
      call = parse_action_opts(opt)
      @@after_action[call] ||= []
      @@after_action[call] << method.to_sym
    end

    def execute_before_action(call)
      call = call.to_sym
      methods = []
      methods += Array(@@before_action[call])
      methods += @@before_action[:'*']
      methods.each do |method|
        self.send(method)
      end
    end

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
