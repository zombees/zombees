# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zombees/version'

Gem::Specification.new do |spec|
  spec.name          = "zombees"
  spec.version       = Zombees::VERSION
  spec.authors       = ["Maxim Filimonov","Solomon White"]
  spec.email         = ["tpaktopsp@gmail.com", "rubysolo@gmail.com"]
  spec.description   = %q{Distributed load testing in Ruby using your own cloud}
  spec.summary       = %q{Distributed load testing in Ruby using your own cloud}
  spec.homepage      = "http://github.com/zombees/zombees"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'celluloid-pmap'
  spec.add_dependency 'celluloid', '~>0.13.0'
  spec.add_dependency 'fog', '~>1.8.0'
  spec.add_dependency 'net-ssh','~>2.5.0'
  spec.add_dependency 'yell'
  spec.add_dependency 'colorize'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'emoji-rspec'
  spec.add_development_dependency 'coveralls'
end
