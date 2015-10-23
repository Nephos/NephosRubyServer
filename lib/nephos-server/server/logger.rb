# coding: utf-8

module Nephos

  module Logger

    @@fd = STDOUT
    def self.write(*what)
      what.flatten.each{|e| @@fd.write("#{e}\n")}
      @@fd.flush
    end

    def self.fd= fd
      @@fd = fd
    end

  end

  def self.log *what
    Logger.write what
  end

end
