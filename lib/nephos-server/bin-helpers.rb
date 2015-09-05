module Nephos
  module Bin

    def self.is_a_valid_application? dir="."
      return false if not Dir.exists? dir
      gfl = File.expand_path "Gemfile.lock", dir
      return false if not File.exists? gfl
      return false if not File.read(gfl).split.index("nephos-server")
      return true
    end

  end
end
