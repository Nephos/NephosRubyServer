# Nephos Ruby Server

[![GitHub version](https://badge.fury.io/gh/pouleta%2FNephosRubyServer.svg)](http://badge.fury.io/gh/pouleta%2FNephosRubyServer)

[![Gem Version](https://badge.fury.io/rb/nephos-server.svg)](http://badge.fury.io/rb/nephos-server)

[![Code Climate](https://codeclimate.com/github/pouleta/NephosRubyServer/badges/gpa.svg)](https://codeclimate.com/github/pouleta/NephosRubyServer)

This is a minimal web server, based on [rack](TODO LINK) and [puma](TODO LINK).
It is written in ruby. It also gives you a minimal architecture
to speed up your application creation.

Features provided:

- Controllers: gives you a resource logic.
- Render: easier render content to the client.
- Router: create a robust and simple routing system, with url variables.

Features wich will not be provided by nephos-server:

- Templating (HTML with variables, loops, ...): It already exists and they are easy to implement.
  - [Slim](DOCUMENTATION/TEMPLATING/SLIM.md)
- Database orm and connector: It already exists and simple to implement
  - [Sequel](DOCUMENTATION/DATABASE/SEQUEL.md)

# Start

```sh
gem install nephos-server # download the server
nephos-generator application MyApp # generate the application
cd MyApp # go in
nephos-server -p 8080 # start the server. port is not required
```


# Documentation

## Guides

Theses guides will provide you knowlegde about everything you can use in the application.

- [Generator GUIDE](DOCUMENTATION/GUIDE_GENERATOR.md)
- [Render API](DOCUMENTATION/API_RENDER.md)
- [Router GUIDE](DOCUMENTATION/GUIDE_ROUTER.md)

## Examples

### Controller

To create a controller, add a ruby file to ``app/``, with a class inherited by ``Nephos::Controller``
The basic code of a controller can be generated via ``nephos-generator controller NAME``.

```ruby
class Example < Nephos::Controller
  def root
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
if the user try to access to an url not described in the file, it will automaticaly render a 404 not found.

```ruby
get url: "/", controller: "MainController", method: "root"       # /
get url: "/add", controller: "MainController", method: "add_url" # /add
get url: "/add/:url", controller: "MainController", method: "add_url" # /add with parameter :url
get url: "/rm", controller: "MainController", method: "rm_url"   # /rm
get url: "/rm/:url", controller: "MainController", method: "rm_url"   # /rm with parameter :url
resource "infos" do
  get url: "/", controller: "MainController", method: "root" # generate /infos
  get url: "/abbout", controller: "MainController", method: "root" # generate /infos/about
end
```


# Developers: Roadmap

## TODO v0.4
- url parameters as resource

## TODO v0.5
- improve generator with application status, tests, more generation (routing, ...)

## TODO v1
- Improved Routing (more helper options)
- Improved Rendering (more options)
- Customisable errors (404 noticely, and 500)
- Guide about
  - Controllers
  - Routing
  - Api Creation
  - Database creation
  - Web HTML with templating
