module Nephos
  class Controller

    attr_reader :env, :infos, :callpath

    # @param env [Hash] env extracted from the http request
    # @param parsed [Hash] pre-parsed env with parameters, ...
    def initialize env={}, parsed={path: [], args: {}}, callpath={params: []}
      @env= env
      @infos= parsed
      @callpath= callpath
      @params= parsed[:args]
      @params.merge! Hash[callpath[:params].zip @infos[:path]]
      @params.select!{|k,v|k}
    end

    def arguments
      @params
    end
    alias :params :arguments

  end
end
