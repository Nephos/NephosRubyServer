# Generator Guide

The ``ngenerator`` is a lite application designed to make easier the application management.

Actually, it allows you to create new application and controller.

## Usage

```bash
ngenerator --mode <options>
```

### Generate new application

```bash
ngenerator --application <name>
```

Create a directory name ``<name>``, initialize a git repository and create basic files.

### Generate new controller

```bash
ngenerator --controller <name>
```

Generate a file ``/app/<downcasename_controller.rb>`` with a class named ``CapitalizeNameController`` inherited by ``Nephos::Controller``.

### Generate new route

```bash
ngenerator --route VERB "/url" "Controller#Method" # or also
ngenerator --route VERB "/url" Controller Method
```

Generate a new route based on the parameters, added to the ``routes.rb`` file.

### Remove a route

```bash
ngenerator --rm --route VERB "/url" "Controller#Method"
```

It will remove a route, generator by the generator, from the ``routes.rb`` file.
