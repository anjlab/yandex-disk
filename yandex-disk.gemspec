# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yandex/disk/version'

Gem::Specification.new do |spec|
  spec.name          = "yandex-disk"
  spec.version       = Yandex::Disk::VERSION
  spec.authors       = ["Yury Korolev"]
  spec.email         = ["yurykorolev@me.com"]
  spec.description   = %q{Ruby client for Yandex.Disk}
  spec.summary       = %q{Ruby client for Yandex.Disk with backup gem support}
  spec.homepage      = "https://github.com/anjlab/yandex-disk"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('faraday', '~> 0.8')
  spec.add_dependency('nokogiri', '~> 1.6.0')
  spec.add_dependency('faraday_middleware', '~> 0.9.0')
  spec.add_dependency('excon', '>= 0.16')

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('rake')
end
