class RoutingError < StandardError; end
class InvalidRoute < RoutingError; end
class InvalidRouteUrl < InvalidRoute; end
class InvalidRouteController < InvalidRoute; end
class InvalidRouteMethod < InvalidRoute; end

class InvalidApplicationError < RuntimeError; end
