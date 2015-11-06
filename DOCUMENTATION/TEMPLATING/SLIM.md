# Slim

Slim is a HTML templating langage, simple to implement in the Nephos Server.
[Slim documentation](http://slim-lang.com)

## Installation
```bash
gem install slim
```

## Usage in Nephos Server
You can add the following code in ``/slim.rb``:

```ruby
def slim(file, locals)
  Slim::Template.new() { File.read('app/views/' + file) }.render(nil, locals)
end
```

### Example
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
