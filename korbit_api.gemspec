lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'korbit_api'
  s.version     = '0.0.0'
  s.date        = '2014-05-29'
  s.summary     = "Korbit Ruby API Wrapper"
  s.description = "Korbit Ruby API Wrapper"
  s.authors     = ["Charlie Moseley"]
  s.email       = 'charlie@robopengu.in'
  s.files       = ["lib/korbit_api.rb"]
  s.files      += Dir.glob('lib/**/*.rb')
  s.homepage    = 'https://github.com/charliemoseley/korbit_api'

  s.add_dependency('typhoeus')
  s.add_dependency('hashie')
  s.add_dependency('rash')
  s.add_dependency('addressable')
end
