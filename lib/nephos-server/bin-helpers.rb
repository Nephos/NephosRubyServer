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
      return false if not File.exist? gfl
      return false if not File.read(gfl).split.index("nephos-server")
      return true
    end

    module Daemon

      def self.started?
        get_pid != nil
      end

      def self.kill!
        d = get_pid
        return false unless d
        begin
          Process::kill(2, d)
        rescue => err
          raise "Cannot kill #{d} ! (#{err.message})" if $debug
          raise "Cannot kill #{d} !"
        ensure
          File.delete(get_pid_file)
        end
        return true
      end

      def self.detach!
        Process::daemon(true, false)
        File.write(get_pid_file, Process::pid.to_s)
      end

      def self.get_pid_file
        return ".pid"
      end

      def self.get_pid
        return nil if not File.exist?(get_pid_file)
        v = File.read(get_pid_file)
        v = Integer(v) rescue nil
        return v
      end

    end

  end

end

class BinError < StandardError; end
