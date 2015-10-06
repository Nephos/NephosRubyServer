# Render API

## What is the Render API ?
The render API is a simple system to allows you to render HTTP responses to a client.
It is a simple way to render data to the user and choose it's type.

The API allows you to customize differents parts of the response:

- HTTP status
- HTTP Content-Type
- Content

Based on the returns of your Controller's methods, it will render to the user
a HTTP response.
You can actually returns HTML, JSON, or PLAIN text, and custom formats if needed.


## Use the API
To use the API, you have to create a new controller.
The controller must be placed or requires in the ``app/`` directory. Check the
[Guide about the controller](GUIDE_CONTROLLER.md).

It must contain a class, inheriting from ``Nephos::Controller``.
Each public method **can** be an entry point, defined in the ``routes.rb`` file.
[Routing documentation](GUIDE_ROUTING.md).

Theses methods, described as "entry points" by your routing rules, must **return** a ``Hash``.
It's format will be described in the following parts.

*Notes: The return may optionnaly be an ``Integer``, to return only a status, or ``:empty``.*

## Returned hash
The return of a Controller method can include the following keys:

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

The following sections will describe how each key works, and modify the HTTP response.

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
