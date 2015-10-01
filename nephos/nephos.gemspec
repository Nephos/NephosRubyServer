Gem::Specification.new do |s|
  s.name        = 'nephos'
  s.version     = '1.0.3'
  s.date        = Time.now.getgm.to_s.split.first
  s.summary     = 'Lite fix'
  s.description = 'Fix usage out of an application'
  s.authors     = [
    'poulet_a'
  ]
  s.email       = 'poulet_a@epitech.eu',
  s.files       = %w(
bin/nserver
bin/ngenerator
bin/nstatus
)
  s.executables = %w(
nserver
ngenerator
nstatus
)
  s.homepage    = 'https://github.com/pouleta/NephosRubyServer'
  s.license     = 'GNU/GPLv3'
  #s.cert_chain  = ['certs/poulet_a.pem']
  #s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/

  s.add_dependency 'nomorebeer', '~> 1.1'
  s.add_dependency 'nephos-server', '~> 0'

end
