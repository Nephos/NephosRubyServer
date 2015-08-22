module Nephos
  class Controller

    attr_reader :env, :infos

    # @params: env [Hash] env extracted from the http request
    # @params: parsed [Hash] pre-parsed env with parameters, ...
    def initialize env, parsed
      @env= env
      @infos= parsed
    end

    def arguments
      @infos[:args]
    end

  end
end
