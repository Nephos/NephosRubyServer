# Render API

## Understand the API

The render API is a simple system to allows you to render HTTP responses to a client.
The API allows you to customize differents parts of the response:

- HTTP status
- HTTP Content-Type
- Content

The API use the returns of the Controllers methods to build the HTTP responses.


## Use the API

To use the API, you have to create a new controller.
The controller must be placed or requires in the ``app/`` directory,
via a ``file.rb`` file.
It must contain a class, wich inherit from ``Nephos::Controller``.
Each public method can be an entry point, defined in the ``routes.rb`` file.
[Routing doc](GUIDE_ROUTING.md).

In the controller, you can use few helpers,
like the method ``params()``, ``env()``, and ``infos()``

The methods used as entry point must return a ``Hash`` described in the following lines.
It may optionnaly be an ``Integer``, to return only a status, or ``:empty``.

## Options

The returns of a Controller method can include the following keys:

- :plain
- :html
- :json
- :content
- :type
- :status

Example:

```ruby
class MyController < Nephos::Controller
  def create
    return {json: {id: 1, name: "Data"}, status: 201}
  end
  def index
    return {type: "text/plain", content: "All your data"}
  end
  def coucou
    return {status: 404}
  end
end
```

The following sections will describe how each key works and modify the HTTP response.

### Content

The ``:content`` key must be associated with a ``String`` (or ``Hash`` is json).

**Optionnal**:
a default value is provided, based on the ``:status`` if no ``:content`` if specified.

### Type

The ``:type`` key has to be associated with a ``String`` matching with **"kind/type"**.

**Optionnal**:
the default value is ``text/plain``

Kinds and Types (called type and sub-type by w3c) are described here:
[the w3c documentation](http://www.w3.org/Protocols/rfc1341/4_Content-Type.html)

#### Kind:

- image
- text
- ...

#### Type:

- plain
- javascript
- jpeg
- ...


### Status

The ``:status`` key is associable with an Integer. It must represent the HTTP status code.

**Optionnal**:
The default value is 200.

[The complete HTTP status code list](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)


### Plain, HTML, JSON

The keys ``:plain``, ``:html``, ``:json`` can replace both ``:content`` ``:type``.
It is associated like ``:content`` and **replace automaticaly the type**.

key | type
---|---
:plain|text/plain
:html|text/html
:json|text/javascript
