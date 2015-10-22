# Slim

Slim is a HTML templating langage, simple to implement in the Nephos Server.
[Slim documentation](http://slim-lang.com)

## Installation

```bash
gem install slim
```

## Usage in Nephos Server

```ruby
require 'slim'

class UserController < Nephos::Controller

  # /user/:id
  def show
    user = User.find(params[:id])
    Slim::Template.new() { File.read('app/views/user/show.slim') }.render(nil, {login: user.login})
  end

end
```
