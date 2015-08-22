class RoutingError < Exception; end
class InvalidRoute < RoutingError; end
class InvalidGetRoute < InvalidRoute; end

# @param: what [Hash]
def get what
  raise InvalidGetRoute if not what.keys.include? :url
  raise InvalidGetRoute if not what.keys.include? :controller
  raise InvalidGetRoute if not what.keys.include? :method

  # TODO: more check to do

  Nephos::Route::ALL << what
  puts "get route: #{what}"
end

# require_relative '../../../routes.rb'
load 'routes.rb'
