class RoutingError < StandardError; end
class InvalidRoute < RoutingError; end
class InvalidRouteUrl < InvalidRoute; end
class InvalidRouteTo < InvalidRoute; end
class InvalidRouteController < InvalidRoute; end
class InvalidRouteMethod < InvalidRoute; end

class InvalidApplication < RuntimeError; end
class InvalidGit < InvalidApplication; end
class NoGitBinary < InvalidGit; end

class ParsingError < StandardError; end
class MissingKey < ParsingError; end
