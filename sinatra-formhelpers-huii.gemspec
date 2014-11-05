# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/form_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'sinatra-formhelpers-huii'
  spec.version       = Sinatra::FormHelpers::VERSION
  spec.authors       = ['twilson63', 'Nate Wiger', 'Cymen Vig', 'Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']
  spec.summary       = %q{Form helpers for Sinatra}
  spec.description   = %q{Simple, lightweight form helpers for Sinatra.}
  spec.homepage      = 'https://github.com/ollie/sinatra-formhelpers-huii'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',   '~> 1.7'
  spec.add_development_dependency 'rake',      '~> 10.3'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'rspec',     '~> 3.1'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'sinatra',   '~> 1.4'
  # spec.add_development_dependency 'pry',       '~> 0.10'
end
