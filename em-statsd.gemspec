# -*- encoding: utf-8 -*-
require File.expand_path('../lib/em-statsd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tim Snowhite"]
  gem.email         = ["tsnowhite@taximagic.com"]
  gem.description   = %q{EventMachine Client for Statsd Reporting}
  gem.summary       = %q{Injects an eventmachine connection into statsd-ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "em-statsd"
  gem.require_paths = ["lib"]
  gem.version       = EM::Statsd::VERSION
  gem.add_dependency 'statsd-ruby', "~>0.2"
  gem.add_dependency 'eventmachine', '~>1.0'
  gem.add_development_dependency(%q<minitest>, [">= 0"])

  
end
