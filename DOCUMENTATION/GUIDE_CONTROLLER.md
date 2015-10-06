# Controller Guide

## Intern architecture

### Cookies
You can set cookies and get them via ``cookies`` in the body of any controller.

Example:
```ruby
    cookies["a"] = "b" # add a cookie named "a"
    cookies.delete("b") # remove a cookie named "b"
```

### Params
You can access to the parameters (defined by http or via the URI, based on your
routing rules).
They are accessible via ``params`` in the body of every controller.

Example:
```ruby
    params[:id] # access to the :id value, for exemple in the url /show/:id
```

### Hooks

A hook is a method, triggered automatically after an action.

Actually, NephosServer allows you to create 2 kinds of triggers for your hooks:

- after_action
- before_action

Your hooks will be called just before/after calling the method requested.
It means that the cookies are not saved yet (so you can change them, etc.) for example.

The hooks are defined by calling the methods ``after_action`` or
``before_action``, out of a method, usually on the top of the controller.

Triggers take 1 or 2 arguments.
- The first is the name of the Hook to use. **This is a required argument**.
- The second **is optional**. It should be a hash, containing ``:only`` or ``:except``
  keys, associated to an Array of Symbols, or one Symbol. Each symbol represents
  a method triggering the hook.

**Note: If there is no 2sd argument, then the hook is triggered every times.**

**Note: except is not already implemented**

Example:
```ruby
class MainController < Nephos::Controller

  before_action :fct_before_all
  before_action :fct_before_root, only: [:root]
  after_action :fct_after_root, only: :root

  def fct_before_all
    # puts "BEFORE ALL"
  end

  def fct_before_root
    # puts "BEFORE"
  end

  def fct_after_root
    # puts "AFTER"
  end

  def root
    # puts "ROOT"
    cookies["a"] = "b"
    cookies.delete("b").to_h
    # puts "Cookies from the root:", cookies
    {
      json: {
        list: $dataset,
        add: '/add',
        rm: '/rm',
      }
    }
  end

end
```
