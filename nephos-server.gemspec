Gem::Specification.new do |s|
  s.name        = 'nephos-server'
  s.version     = File.read("version")
  s.date        = Time.now.getgm.to_s.split.first
  s.summary     = File.read("CHANGELOG").match(/^v[^\n]+\n((\t[^\n]+\n)+)/m)[1].split("\t").join
  s.description = ' a minimalist server, based on rack/puma, with routing, rendering, and controllers. Designed for quick api.'
  s.authors     = ['poulet_a']
  s.email       = ['poulet_a@epitech.eu']
  s.files       = %w(
lib/nephos-server.rb
lib/nephos-server/basic_errors.rb
lib/nephos-server/cookies.rb
lib/nephos-server/bin-helpers.rb
lib/nephos-server/controller.rb
lib/nephos-server/params.rb
lib/nephos-server/router/main.rb
lib/nephos-server/router/load.rb
lib/nephos-server/router/helpers.rb
lib/nephos-server/server/logger.rb
lib/nephos-server/server/main.rb
lib/nephos-server/server/responder.rb
lib/nephos-server/version.rb

README.md
DOCUMENTATION/API_RENDER.md
DOCUMENTATION/GUIDE_CONTROLLER.md
DOCUMENTATION/GUIDE_GENERATOR.md
DOCUMENTATION/GUIDE_ROUTER.md
DOCUMENTATION/DATABASE/SEQUEL.md
DOCUMENTATION/TEMPLATING/SLIM.md
CHANGELOG

Rakefile
Procfile
Gemfile
Gemfile.lock
nephos-server.gemspec
version

test/test.rb
test/responder.rb
test/router.rb
test/params.rb
test/logger.rb
test/controller.rb

test/functional.rb
test/functional/controller.rb
test/functional/generator.rb
test/functional/global.rb
test/functional/router.rb
test/functional/server.rb
routes.rb

app/dataset.rb
app/image.jpg
app/main.rb
bin/nephos-server
bin/nephos-generator
bin/nephos-status
)
  s.executables = %w(
nephos-server
nephos-generator
nephos-status
)
  s.homepage    = 'https://github.com/Nephos/NephosRubyServer'
  s.license     = 'GNU/GPLv3'

  s.cert_chain  = ['certs/nephos.pem']
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/

  # s.add_dependency 'nephos', '~> 1.0'
  s.add_dependency 'nomorebeer', '~> 1.1'
  s.add_dependency 'rack', '~> 1.6'
  s.add_dependency 'colorize', '~> 0.7'
  s.add_dependency 'puma', '~> 2.13'

end
