# Generator Guide

The ``nephos-generator`` is a lite application designed to make easier the application management.

Actually, it allows you to create new application and controller.

## Usage

```bash
nephos-generator [what] <options>
```

### Generate new application

```bash
nephos-generator application <name>
```

Create a directory name ``<name>``, initialize a git repository and create basic files.

### Generate new controller

```bash
nephos-generator controller <name>
```

Generate a file ``/app/<downcasename.rb>`` with a class named ``CapitalizeNameController`` inherited by ``Nephos::Controller``.

### Generate new route

```bash
nephos-generator route VERB "/url" "Controller#Method"
```

Generate a new route based on the parameters, added to the ``routes.rb`` file.

### Remove a route

```bash
nephos-generator --rm route VERB "/url" "Controller#Method"
```

It will remove a route, generator by the generator, from the ``routes.rb`` file.
