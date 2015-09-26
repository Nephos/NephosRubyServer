module Nephos
  VERSION_FILE = __FILE__.split("/")[0..-4].join("/") + "/version"
  VERSION = File.read(VERSION_FILE).strip

  @@env = $server_env

  def self.env
    @@env
  end

  def self.env= env
    @@env = env
  end

end
