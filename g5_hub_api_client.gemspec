# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'g5_hub_api_client'
  spec.version       = '0.0.0'
  spec.authors       = ['Jonathan Samples']
  spec.email         = ['jonathan.samples@g5searchmarketing.com']
  spec.summary       = %q{G5 Hub API Client}
  spec.description   = %q{Client gem that enables easy access to the G5 Hub APIs}
  spec.homepage      = 'http://getg5.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rake'
end
