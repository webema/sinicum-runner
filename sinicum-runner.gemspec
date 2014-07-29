# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinicum-runner/version'

Gem::Specification.new do |gem|
  gem.name          = "sinicum-runner"
  gem.version       = Sinicum::Runner::VERSION
  gem.authors       = ["Patrik Metzmacher", "Daniel Trierweiler"]
  gem.email         = ["sinicum@dievision.de"]
  gem.description   = "A gem to easily run Magnolia CMS in a Tomcat instance"
  gem.summary       = "Simple embedded Tomcat server"
  gem.homepage      = "https://github.com/dievision/sinicum-runner"
  gem.license       = "MIT/Apache-2.0"

  gem.files         = `git ls-files`.split($/)
  gem.files         += Dir['lib/java/**/*.jar']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake', '> 10.3'
  gem.add_development_dependency 'rspec', '~> 3.0'
end
