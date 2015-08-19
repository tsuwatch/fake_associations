# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fake_associations/version'

Gem::Specification.new do |spec|
  spec.name          = "fake_associations"
  spec.version       = FakeAssociations::VERSION
  spec.authors       = ["Tomohiro Suwa"]
  spec.email         = ["neoen.gsn@gmail.com"]

  spec.summary       = %q{To enable to use ActiveRecord association in the module is not ActiveRecord.}
  spec.description   = %q{To enable to use ActiveRecord association in the module is not ActiveRecord.}
  spec.homepage      = "https://github.com/tsuwatch/fake_associations"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
