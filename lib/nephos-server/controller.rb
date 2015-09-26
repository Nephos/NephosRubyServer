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

  end
end
