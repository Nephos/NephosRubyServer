# Nephos Ruby Server

[![GitHub version](https://badge.fury.io/gh/pouleta%2FNephosRubyServer.svg)](http://badge.fury.io/gh/pouleta%2FNephosRubyServer)

[![Gem Version](https://badge.fury.io/rb/nephos-server.svg)](http://badge.fury.io/rb/nephos-server)

[![Code Climate](https://codeclimate.com/github/pouleta/NephosRubyServer/badges/gpa.svg)](https://codeclimate.com/github/pouleta/NephosRubyServer)

This is a simple web server, based on rack and puma, with a minimal help:

- Controllers
- Rendering
- Routing


# TODO

- Database connection


# Start

```sh
gem install nephos-server
nephos-generator application MyApp
cd MyApp
nephos-server -p 8080 # port is not required
```


# Documentation

## Controller

To create a controller, simply add it to ``controllers/``.
The basic code of a controller can be generated via ``nephos-generator controller NAME``.

```ruby
class Example < Nephos::Controller
  def root
    return {plain: "index"}
  end
end
```

## Rendering

In a controller, use:

```ruby
return {status: code}
return {status: code, content: "Not today"}
return {json: {status: "resource created"}, status: 201}
return {plain: "text"}
return {html: "<html><body><h1>:D</h1></body></html>"}
return {type: "image/jpeg", content: File.read("images/photo.jpg")}
return :empty
```

## Routing

Like in ``/routes.rb``, you have to route manually the api.

```ruby
get url: "/", controller: "MainController", method: "root"       # /
get url: "/add", controller: "MainController", method: "add_url" # /add
get url: "/add/:url", controller: "MainController", method: "add_url" # /add
get url: "/rm", controller: "MainController", method: "rm_url"   # /rm
get url: "/rm/:url", controller: "MainController", method: "rm_url"   # /rm
resource "infos" do
  get url: "/", controller: "MainController", method: "root" # generate /infos
end
```
