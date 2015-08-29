def route_prefix
  @route_prefix ||= []
  File.join(["/"] + @route_prefix)
end

def add_route(what, verb)
  raise InvalidRoute unless what.is_a? Hash
  what[:url] = File.expand_path File.join(route_prefix, what[:url])
  Nephos::Router.check!(what)
  Nephos::Router.add_params!(what)
  Nephos::Router.add(what, verb)
end

# @param what [Hash]
def get what
  add_route what, "GET"
end

# @param what [Hash]
def post what
  add_route what, "POST"
end

# @param what [Hash]
def put what
  add_route what, "PUT"
end

def resource(name, &block)
  @route_prefix ||= []
  @route_prefix << name
  block.call
  @route_prefix.pop
end
