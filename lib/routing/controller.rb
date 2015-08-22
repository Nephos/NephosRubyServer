module Nephos
  class Controller

    attr_reader :env, :infos

    def initialize env, parsed
      @env= env
      @infos= parsed
    end

    def arguments
      @infos[:args]
    end

  end
end
