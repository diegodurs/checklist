Gem::Specification.new do |s|
  s.name        = 'checkthelist'
  s.version     = '0.0.3'
  s.date        = '2013-11-19'
  s.summary     = "Checklist helper"
  s.description = "Lets you create your list of rules and see them checked once the provided block return true"
  s.authors     = ["Diego d'Ursel"]
  s.email       = 'diegodurs@gmail/com'
  s.files       = Dir["lib/**/*"]
  s.files      += Dir['spec/**/*']
  s.files      += Dir['app/**/*']
  s.homepage    = 'http://rubygems.org/gems/checkthelist'
  s.license     = 'MIT'
end