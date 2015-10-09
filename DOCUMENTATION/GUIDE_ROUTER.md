
# Routing Guide

### How the routes are inputed by the client ?
Each HTTP request made by the client will contains a **REQUEST_URI** value.
The web server receive this information, and will choose what to do,
based on the rules you will define.

### How to define the rules ?
The rules definitions are writen in the ``/routes.rb`` file.
Few helpers are provided to make the job easier.
They will be described in the section ([helpers](#the-helpers)).

### Is there default rules ?
No there is not, but, there is still 2 kind of response that you cannot route:

1. If you did not write the route requested, then it will be a 404 error.
2. If the controller contains errors (not a valid return, or uncaught exception), then a 505 is returned.

To handle these errors, your should see [error guide](GUIDE_ERRORS.md).


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

**Note: if you are as lazy as me, you also can specifie the url out of the hash (option).
It can be done by putting the url as second argument, like in the following example.
This note is also valid for the next helpers (get, post, put)**
```ruby
add_route "GET", "/tmp", controller: "MyController", method: "tmp"
```

### get post put
Theses 3 helpers allows you to use ``add_route`` without the first argument.

Example:
```ruby
get url: "/tmp", controller: "MyController", method: "tmp"
post url: "/tmp", controller: "MyController", method: "tmp"
```
### resource
This method takes 1 parameter and 1 block.
The parameter is a partial url, and the bloc, other routes.

Resource can be chained many times.

For example, you can do this:
```ruby
resource "user" do
get url: "/index", controller: "UserController", method: "show" # /user/index
  resource "informations" do
    get url: "/", controller: "UserController", method: "show" # /user/informations/
  end
end
```

## URL Parameters
The parameters can be passed through the URL. To allow a resource to have
parameters, you will have to place a  ``/:param`` in your route rules. The
parameter will be placed in the controller in the ``params`` method, an be
accessible via ``params[:param]``. This is the reason why you should never
have 2 URL parameters with the same name, because only the last will be usable.

Example:
```ruby
resource "user" do
  get url: "/:id", controller: "UserController", method: "show" # /user/(anything)
end
resource "static" do
  resource ":page" do
    get url: "/", controller: "StaticPageController", method: "show" # /static/(anything)
    get url: "/edit", controller: "StaticPageController", method: "edit" # /static/(anything)/edit
    put url: "/", controller: "StaticPageController", method: "update" # /static/(anything)
  end
end
```

## Notes

* When a request is done, duplicate / are not counted. So, ``/resource/id`` is equivalent to ``////resource//id`` etc.
* It is possible, by default, to add a postfixed extension (like .html) to your rules. It is accessible via the controller (``extension`` method). It can be disabled by adding the option ``postfix: false``
* You can replace the both keys ``:controller`` and ``:method`` by ``:to``, which has to be associated with a string like ``Controller#method``
