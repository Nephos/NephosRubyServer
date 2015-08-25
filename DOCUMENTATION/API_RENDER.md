# Render API

The render API is designed to control the http response.
It includes:

- HTTP status
- HTTP Content-Type
- Content

## Use the API

To use the API, you have to create a new controller.
The controller must be placed or requires in the ``controllers/`` directory, via a ``file.rb`` file. It must contain a class, wich inherit from ``Nephos::Controller``.
Each public method can be an entry point, defined in the ``routes.rb`` file. [Routing doc](GUIDE_ROUTING.md).

The methods used as entry point must return a ``Hash`` described in the following lines.

### Render

The returns can include the following keys:

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

#### Content

The ``:content`` key must be associated with a ``String`` (or ``Hash`` is json).

**Optionnal** : default value in function of the status

#### Type

The ``:type`` key has to be associated with a ``String`` matching with **"kind/type"**, where:

**Optionnal** : default value is "text/plain"

Kind:

- image
- text
- ... (see [the w3c documentation](http://www.w3.org/Protocols/rfc1341/4_Content-Type.html))

Type:

- plain
- javascript
- jpeg
- ...

#### Status

The ``:status`` key is associable with an Integer. It must represent the HTTP status code.

**Optionnal** : it's default value is 200.

[The complete HTTP status code list](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)


#### Plain, HTML, JSON

The keys ``:plain``, ``:html``, ``:json`` can replace both ``:content`` ``:type``. It is associated like ``:content`` and replace automaticaly it's type.

key | type
---|---
:plain|text/plain
:html|text/html
:json|text/javascript
