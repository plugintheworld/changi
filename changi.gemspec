Gem::Specification.new do |s|
  s.name        = 'changi'
  s.version     = '0.2.1'
  s.license     = 'MIT'
  s.summary     = 'Tiny library of changelog management rake tasks.'
  s.description = 'Manages a set of changelog entries for you and combines them to a changelog file when you release.'
  s.authors     = ['Mobisol GmbH']
  s.email       = 'dev@plugintheworld.com'
  s.files       = Dir['lib/**/*rb']
  s.homepage    = 'https://github.com/plugintheworld/changi'

  s.add_dependency 'rake', '~> 10.4'
  s.add_dependency 'highline', '~> 1.7'
end
