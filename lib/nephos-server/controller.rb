module Nephos
  class Controller

    attr_reader :env, :infos, :callpath, :params

    # @param env [Hash] env extracted from the http request
    # @param parsed [Hash] pre-parsed env with parameters, ...
    def initialize env={}, parsed={path: [], args: {}}, callpath={params: []}
      raise ArgumentError, "env must be a Hash" unless env.is_a? Hash
      raise ArgumentError, "parsed must be a Hash" unless parsed.is_a? Hash
      raise ArgumentError, "callpath must be a Hash" unless callpath.is_a? Hash
      raise ArgumentError, "Invalid Parsed. :path must be associated with an Array" unless parsed[:path].is_a? Array
      raise ArgumentError, "Invalid Parsed. :args must be associated with a Hash" unless parsed[:args].is_a? Hash
      raise ArgumentError, "Invalid Callpath. :params must be associated with an Array" unless callpath[:params].is_a? Array
      @env= env
      @infos= parsed
      @callpath= callpath
      @params= parsed[:args]
      @params.merge! Hash[callpath[:params].zip @infos[:path]]
      @params.select!{|k,v| not k.to_s.empty?}
      @params = Params.new(@params)
    end

  end
end
