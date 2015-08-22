# Nephos Ruby Server

This is a simple web server, based on rack and puma, with a minimal help:

- Controllers
- Rendering
- Routing


# TODO

- Improve rendering
  - html support
- Routing
  - improve get with arguments
  - add post and put (like get)
  - add ressource (elarge urls)
- Database connection


# Start

```sh
gem install nephos-server
nephos-server -p 8080 # port is not required
```


# Documentation

## Controller

To create a controller, simply add it to ``src/``.
The basic code of a controller can be generated via ``bin/generate controller NAME``.

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
return {json: {...}}
return {plain: "text"}
return :empty
```

## Routing

Like in ``/routes.rb``, you have to route manually the api.

```ruby
get url: "/", controller: "MainController", method: "root"
get url: "/add", controller: "MainController", method: "add_url"
get url: "/rm", controller: "MainController", method: "rm_url"
```
