module Nephos
  module Bin

    # @param dir [String]
    #
    # The method check in the parameter directory:
    # - if the directory exists
    # - if a Gemfile.lock has been generated
    # - if it contain nephos-server dependency
    #
    # note: if the Gemfile includes nephos and not nephos-server,
    # it will work anyway, because nephos require nephos-server
    def self.is_a_valid_application? dir="."
      return false if not Dir.exists? dir
      gfl = File.expand_path "Gemfile.lock", dir
      return false if not File.exists? gfl
      return false if not File.read(gfl).split.index("nephos-server")
      return true
    end

  end
end

class BinError < StandardError; end
