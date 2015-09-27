module Nephos

  # This class must be inherited by the other Controllers.
  # It contains a constructor (you should not rewrite it)
  # It contains some helpers too, like an access to the environment,
  # and the parameters.
  class Controller

    attr_reader :env, :infos, :callpath, :params, :cookies
    attr_reader :req

    # @param env [Hash] env extracted from the http request
    # @param parsed [Hash] pre-parsed env with parameters, ...
    def initialize env={}, parsed={path: [], params: {}}, callpath={params: []}
      raise ArgumentError, "env must be a Hash" unless env.is_a? Hash
      raise ArgumentError, "parsed must be a Hash" unless parsed.is_a? Hash
      raise ArgumentError, "callpath must be a Hash" unless callpath.is_a? Hash
      raise ArgumentError, "Invalid Parsed. :path must be associated with an Array" unless parsed[:path].is_a? Array
      raise ArgumentError, "Invalid Parsed. :params must be associated with a Hash" unless parsed[:params].is_a? Hash
      raise ArgumentError, "Invalid Callpath. :params must be associated with an Array" unless callpath[:params].is_a? Array
      @env= env
      @req= Rack::Request.new(env)
      @infos= parsed
      @callpath= callpath
      @params= parsed[:params]
      @params.merge! Hash[callpath[:params].zip @infos[:path]]
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
