module Nephos
  class Controller

    def initialize env, parsed
      @env= env
      @infos= parsed
    end

    def arguments
      @infos[:args]
    end

  end
end
