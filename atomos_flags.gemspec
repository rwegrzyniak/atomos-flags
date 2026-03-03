# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "atomos_flags"
  spec.version       = "0.1.0"
  spec.authors       = ["Rafał (CEO)", "CTO/Architect"]
  spec.email         = ["cto@atomos.platform"]

  spec.summary       = "Elegant and lightweight feature flags for Rails apps."
  spec.description   = "Targeting by context, user email, and deterministic percentage rollout."
  spec.homepage      = "https://github.com/rwegrzyniak/atomos_flags"
  spec.license       = "MIT"

  spec.files         = Dir["{app,lib}/**/*", "MIT-LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.add_dependency "rails", ">= 7.0"
end
