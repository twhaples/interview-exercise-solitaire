# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sol/version'

Gem::Specification.new do |spec|
  spec.name          = "sol"
  spec.version       = Sol::VERSION
  spec.authors       = ["Thomas Whaples"]
  spec.email         = ["fennec@gmail.com"]
  spec.summary       = %q{Solitaire.}
  spec.description   = %q{Solitaire. The Klondike version. For MergerMarket.}
  spec.homepage      = ""
  spec.license       = "Proprietary"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "test-redef"
  
end
