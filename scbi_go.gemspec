# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scbi_go/version'

Gem::Specification.new do |spec|
  spec.name          = "scbi_go"
  spec.version       = ScbiGo::VERSION
  spec.authors       = ["dariogf"]
  spec.email         = ["dariogf@gmail.com"]
  spec.summary       = %q{GeneOntology tools.}
  spec.description   = %q{GeneOntology tools to summarize and graph go terms}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  #spec.add_development_dependency "autotest"
  spec.add_development_dependency "guard-rspec"
  
  spec.add_runtime_dependency "obo"
  spec.add_runtime_dependency "gene_ontology"
end
