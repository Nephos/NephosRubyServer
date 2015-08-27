# coding: utf-8

module Nephos
  class Params

    def initialize(hash={})
      raise ArgumentError, "the first argument must be a Hash" unless hash.is_a? Hash
      @hash = Hash[hash.map{|k,v| [k.to_s, v]}]
    end

    def method_missing m, *a
      @hash.send(m, *(a.map(&:to_s)))
      @hash.send(m, *a)
    end

    def [] i
      @hash[i.to_s]
    end

    def []= i, v
      @hash[i.to_s] = v.to_s
    end

  end
end
