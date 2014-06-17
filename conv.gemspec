# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'conv/version'

Gem::Specification.new do |spec|
  spec.name          = "conv"
  spec.version       = Conv::VERSION
  spec.authors       = ["Eiji Takahashi"]
  spec.email         = ["tak7iji@gmail.com"]
  spec.summary       = %q{Converter for TUBAME}
  spec.description   = %q{Convert XLSX or CSV to XML, XML to XLSX or CSV}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "xlsx_writer"
  spec.add_runtime_dependency "roo"
  spec.add_runtime_dependency "nokogiri"
end
