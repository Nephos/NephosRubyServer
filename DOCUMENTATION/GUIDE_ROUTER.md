# Routing Guide

## Why using routes ?

If you begin on the web, you must understand that a request on "web.com/path" will not "take the file and render to the client". The request will be handled by the server (Nephos) to compute and render the rights data (maybe the content of a file).

You will have to specifie the routes usables by the user.

## Create a route

To do it, checkout the ``routes.rb`` file.

Nephos-Server allows you to use 5 helpers:

### get, post, put

The 3 calls add_route with your parameters + the HTTP verb (GET, POST, or PUT).
It take has parameter 1 ``Hash``. See ``add_route`` just on the following lines.

### add_route

``add_route(what, verb)`` takes 2 parameters:

- what: ``Hash``. It requires 3 keys:
  - ``:url``: specifies the url that will be used to match with the user request.
  - ``:controller``: specifies the controller class that will be used.
  - ``:method``: specifies the method of the controller that will be used to compute and render a result to the user.
- verb: ``String``. It can be **GET**, **POST**, **PUT**, **DELETE**, or anything you like. But try to respect the standards.

### resource

resource take 1 parameter and 1 block. The parameter is a partial url, and the bloc, other routes.

resource can be chained many times. For Example, you can do this:

```ruby
resource "home" do
  resource "/index" do
    get url: "/", controller: "MainController", method: "root"
  end
end
```

It will generate the route ``/home/index``, calling the ``MainController#root`` method.


## URL Parameters

place a ``/:param`` in your route. The parameter will be placed in the controller in the ``params`` method
