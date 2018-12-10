# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dealersocket/client/version'

# shortening this method would arguablly make this less readable
# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'dealersocket-client'
  spec.version       = Dealersocket::Client::VERSION
  spec.authors       = ['Stephen Thomas']
  spec.email         = ['sthomas@t2modus.com']

  spec.summary       = 'Dealersocket Ruby SDK'
  spec.description   = 'A Ruby SDK providing simple integration with the Dealersocket CRM REST API'
  spec.homepage      = 'https://github.com/t2modus/dealersocket-client'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'http'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'webmock'
end
# rubocop:enable Metrics/BlockLength
