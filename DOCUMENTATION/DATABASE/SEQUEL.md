# Sequel

Sequel is an orm and database connector.
It is easy to use and configure.

It handles connection with DB, sql request creation, caching, etc.

## Installation

```bash
gem install sequel
```

## Usage

```ruby
require 'sequel'
DB = Sequel.connect(ENV['DATABASE_URL'])
```

[Sequel documentation](http://sequel.jeremyevans.net/documentation.html)
