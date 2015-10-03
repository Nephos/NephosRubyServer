# Nephos Ruby Server
[![Gem Version](https://badge.fury.io/rb/nephos-server.svg)](http://badge.fury.io/rb/nephos-server)

This is a minimal web server, based on [rack](https://github.com/rack/rack) and [puma](https://github.com/puma/puma).
It is written in ruby. It also gives you a minimal architecture
to speed up your application bootstrap.

Features provided:

- Controllers: gives you a resource logic.
- Render: easier render content to the client.
- Router: create a robust and simple routing system, with url variables.

Features which will not be provided by nserver:

- Templating (HTML with variables, loops, ...): It already exists and it is easy to implement.
  - [Slim](DOCUMENTATION/TEMPLATING/SLIM.md)
- Database orm and connector: It already exists and simple to implement too.
  - [Sequel](DOCUMENTATION/DATABASE/SEQUEL.md)

# Start
```sh
gem install nephos # download the server and executables
ngenerator application MyApp # generate the application
cd MyApp # go in
nserver -p 8080 -h 0.0.0.0 # start the server. port is not required, neither host
```

``nserver`` is an executable designed to start the server easly. It can take few arguments, all optionnal:

- ``-p``: port to listen
- ``-h``: host to listen (network address)
- ``-e``: environment (default is development, can be set to production)
- ``-d``: daemonize the process
- ``-k``: kill daemonized process


# Documentation

## Guides
Theses guides will provide you knowlegde about everything you can use in the application.

- [Generator GUIDE](DOCUMENTATION/GUIDE_GENERATOR.md)
- [Render API](DOCUMENTATION/API_RENDER.md)
- [Router GUIDE](DOCUMENTATION/GUIDE_ROUTER.md)
- [Controller GUIDE](DOCUMENTATION/GUIDE_CONTROLLER.md)
- [Customisable errors GUIDE](DOCUMENTATION/GUIDE_ERRORS.md)
- [Code documentation on RubyDoc.info](http://www.rubydoc.info/gems/nephos-server/toplevel) -> **Note: you can also generate local documentation via yard**

## Examples

### Production and environment
To avoid information leaks from your application, set the environment variable
``export ENVIRONMENT=production``, or run the server with ``-e production``
parameter. When an error occurs, the backtrace will be print to the client in
the rendered page, unless the server runs in production environment.

### Controller
Every routes will call a method from a controller.
To create a controller, add a ruby file to ``app/``, with a class inherited by ``Nephos::Controller``
You should user ``ngenerator --controller NAME`` to generate a new controller.

```ruby
class Example < Nephos::Controller
def root
    cookies["last_visit"] = Time.now
    if params["index"] == "true"
      return {plain: "index"}
    else
	  return :empty
	end
  end
end
```

### Rendering
To render a content to the client, you can return informations from a Controller method:

```ruby
return 404
return {status: code}
return {status: code, content: "Not today"}
return {json: {status: "resource created"}, status: 201}
return {plain: "text"}
return {html: "<html><body><h1>:D</h1></body></html>"}
return {type: "image/jpeg", content: File.read("images/photo.jpg")}
return :empty
```

### Routing
The routing (rules to execute the action the user wants), you have to write the ``/routes.rb`` file.
If the user try to access an url not described in the file, it will automaticaly render a 404 not found.

```ruby
get url: "/", controller: "MainController", method: "root"       # /
post url: "/add", controller: "MainController", method: "add_url" # /add
post url: "/add/:url", controller: "MainController", method: "add_url" # /add with parameter :url
put url: "/rm", controller: "MainController", method: "rm_url"   # /rm
put url: "/rm/:url", controller: "MainController", method: "rm_url"   # /rm with parameter :url
resource "infos" do
  get url: "/", controller: "MainController", method: "root" # generate /infos
  get url: "/about", controller: "MainController", method: "root" # generate /infos/about
end
```


# Developers: Roadmap

## TODO v0.6
- Alias for routing
- functionnal tests
- extension for urls (optional .xxx, with controller effect)

## TODO v0.7
- feature to change HTTP header from controller
- Documentation on architecture (UML)
- Improved documentation (Tutorial, Improved guides)

## v1 requierements
- Environement, Daemons, Port, Listen Host, Routables, Arguments
- Clear architecture
- Generator readables and powerfull
- At least 80% tests coverage
- Performances benchmark
- Guide about
  - Controllers
  - Routing
  - Api Creation
  - Database creation
  - Web HTML with templating
- Clear documentation on the features using regexp, options, ...

Gitlab Continuous Integration:
[![Gitlab Tests](https://gitlab.com/ci/projects/8973/status.png?ref=master)](https://gitlab.com/ci/projects/8973?ref=master)

Github version
[![GitHub version](https://badge.fury.io/gh/pouleta%2FNephosRubyServer.svg)](http://badge.fury.io/gh/pouleta%2FNephosRubyServer)

Released version on ruby-gems
[![Gem Version](https://badge.fury.io/rb/nephos-server.svg)](http://badge.fury.io/rb/nephos-server)

Code Quality
[![Code Climate](https://codeclimate.com/github/pouleta/NephosRubyServer/badges/gpa.svg)](https://codeclimate.com/github/pouleta/NephosRubyServer)

Nephos gem version
[![Nephos Executables](https://badge.fury.io/rb/nephos.svg)](http://badge.fury.io/rb/nephos)
