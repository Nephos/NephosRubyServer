# coding: utf-8

module Nephos

  # Params to a hash, where every elements are accessibles via a stringified key
  # so, even if the entry was added with the key :KEY, it will be accessible via
  # a string equivalent to :key.to_s
  #   param["key"] == param[:key]
  #
  # Every methods present in {Hash} are usable in {Param}.
  class Cookies < Params

    # @param hash [Hash] hash containing the parameters
    def initialize(hash={})
      raise ArgumentError, "the first argument must be a Hash" unless hash.is_a? Hash
      # TODO: take care of the path
      @hash = Hash[hash.map{|k,v| [k.to_s, {content: v, path: "/"}]}]
    end

    def method_missing m, *a
      @hash.send(m, *(a.map(&:to_s)))
      @hash.send(m, *a)
    end

    def [] i
      @hash[i.to_s][:content]
    end

    def []= i, v, path="/"
      @hash[i.to_s] = {content: v.to_s, path: path.to_s}
    end

    def path i
      @hash[i.to_s][:path]
    end

    def set_path i, v
      raise InvalidPath, v unless v.is_a? String
      @hash[i.to_s][:path] = URI.encode(v)
    end

    def to_h
      return @hash
    end
    alias :to_hash :to_h

    def to_s
      return to_h.to_s
    end

  end
end
