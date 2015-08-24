class RoutingError < StandardError; end
class InvalidRoute < RoutingError; end
class InvalidRouteUrl < InvalidRoute; end
class InvalidRouteController < InvalidRoute; end
class InvalidRouteMethod < InvalidRoute; end

class InvalidApplication < RuntimeError; end
class InvalidGit < InvalidApplication; end
class NoGitBinary < InvalidGit; end
