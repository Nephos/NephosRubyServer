# Routing Guide

## How the routes are inputed by the client ?

Each HTTP request made by the client will contains a **REQUEST_URI** value.
The web server receive this information, and will choose what to do,
based on the rules you will define.

## How to define the rules ?

You have to write the rules in the ``/routes.rb`` file.
Few helpers are provided to make the job easier.
They will be described in the following section.

## The helpers

As every HTTP request requires an HTTP verb, there is 4 helpers to handle them.
``get``, ``post``, ``put``, ``add_route``. Indeed, there is 3 main verbs (GET POST PUT).
But as you can need to create other verbs (DELETE, PATCH, ...), we allows you to handle them.

### add_route

The method ``add_route`` take 2 arguments.

1. verb (has to be a string, upcase as possible, like **GET**)
2. option (a **Hash** with 3 required keys)

The option argument must contains the 3 following keys:

- ``:url``: the url to handle (client input)
- ``:controller``: the controller to use
- ``:method``: the method of the controller that will be used to compute and render a result to the client.

As example, yuo can write:

```ruby
add_route "GET", url: "/tmp", controller: "MyController", method: "tmp"
```

### get post put

Theses 3 helpers allows you to use ``add_route`` without the first argument.

### resource

This method takes 1 parameter and 1 block.
The parameter is a partial url, and the bloc, other routes.

Resource can be chained many times.
For Example, you can do this:

```ruby
resource "user" do
  resource "informations" do
    get url: "/index", controller: "UserController", method: "show" # /user/informations/index
  end
end
```

It will generate the route ``/home/index``, calling the ``MainController#root`` method.


## URL Parameters

**TODO**

place a ``/:param`` in your route. The parameter will be placed in the controller in the ``params`` method
