class RoutingError < Exception; end
class InvalidRoute < RoutingError; end
class InvalidGetRoute < InvalidRoute; end

module Nephos
  module Route

    def self.add(what, verb)
      Nephos::Route::ALL << what.merge(verb: verb)
      puts "#{verb} #{what}"
    end

    def self.check!(what)
      raise InvalidGetRoute if not what.keys.include? :url
      raise InvalidGetRoute if not what.keys.include? :controller
      raise InvalidGetRoute if not what.keys.include? :method
      # TODO: more check to do
    end

  end
end

# @params: what [Hash]
def get what
  Nephos::Route.check!(what)
  Nephos::Route.add(what, :get)
end

# @params: what [Hash]
def post what
  Nephos::Route.check!(what)
  Nephos::Route.add(what, :post)
end

# @params: what [Hash]
def put what
  Nephos::Route.check!(what)
  Nephos::Route.add(what, :put)
end

load 'routes.rb'
