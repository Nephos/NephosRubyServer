def route_prefix
  @route_prefix ||= []
  File.join(["/"] + @route_prefix)
end

# @param verb [String] has to be a valid http verb, so a string uppercase
# @param url [String] if an url is provided, then it will be put in the hash
#   to have the same behavior as if it was specified in the what hash
#   \\{url: URL}
# @param what [Hash] has to contain the following keys:
#   - :url
#   - :controller
#   - :method
#
# The method create a valid route, set in Nephos::Router::ROUTES
# it will call the method from the controller, based on the parameters
# if the client request match with the verb and the url provided.
#
# Checkout the documentation about the parameters and API for more informations
def add_route(verb, url=nil, what)
  raise InvalidRoute, "what must be a hash" unless what.is_a? Hash
  what[:url] ||= url
  what[:url] = File.expand_path File.join(route_prefix, what[:url])
  Nephos::Router.check!(what)
  Nephos::Router.add_params!(what)
  Nephos::Router.add(what, verb)
end

# @param url [String] see {#add_route}
# @param what [Hash] see {#add_route}
def get url=nil, what
  add_route "GET", url, what
end

# @param url [String] see {#add_route}
# @param what [Hash] see {#add_route}
def post url=nil, what
  add_route "POST", url, what
end

# @param url [String] see {#add_route}
# @param what [Hash] see {#add_route}
def put url=nil, what
  add_route "PUT", url, what
end

# @param name [String]
# @param block [Bloc]
#
# Create a resource named based on the parameter name
# Every call of {#add_route} {#get} {#post} {#put} in the bloc
# will have a modified url, working with the following schema:
#   "/name/" + url
def resource(name, &block)
  @route_prefix ||= []
  @route_prefix << name
  block.call
  @route_prefix.pop
end

# An alias is an url which have the same proprieties than the previous route
def alias_route
  raise "Not implemented yet"
end
