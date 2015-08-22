Gem::Specification.new do |s|
  s.name        = 'nephos-server'
  s.version     = File.read("version")
  s.date        = Time.now.getgm.to_s.split.first
  s.summary     = 'See Changelog'
  s.description = ' a minimalist server, based on rack/puma, with routing, rendering, and controllers. Designed for quick api.'
  s.authors     = [
            	  'poulet_a'
		  ]
  s.email       = 'poulet_a@epitech.eu',
  s.files       = [
               	  'lib/nephos-server.rb',
               	  'lib/nephos-server/server/main.rb',
               	  'lib/nephos-server/server/responder.rb',
               	  'lib/nephos-server/routing/execute.rb',
               	  'lib/nephos-server/routing/load.rb',
               	  'lib/nephos-server/routing/controller.rb',
                  'routes.rb.example',
		  'README.md',
		  'Rakefile',
		  'Procfile',
                  'Gemfile',
                  'Gemfile.lock',
		  'nephos-server.gemspec',
                  'version',
		  'test/test.rb',
                  'bin/nephos-server',
                  'bin/nephos-generator'
  ]
  s.executables = ['nephos-server', 'nephos-generator']
  s.homepage    = 'https://github.com/pouleta/NephosRubyServer'
  s.license     = 'GNU/GPLv3'
  #s.cert_chain  = ['certs/poulet_a.pem']
  #s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/
end
