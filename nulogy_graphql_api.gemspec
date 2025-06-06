require_relative "lib/nulogy_graphql_api/version"

Gem::Specification.new do |spec|
  spec.name = "nulogy_graphql_api"
  spec.version = NulogyGraphqlApi::VERSION
  spec.authors = ["Daniel Silva"]
  spec.email = ["danielsi@nulogy.com"]

  spec.summary = "Standard tooling for building GraphQL apis"
  spec.homepage = "https://github.com/nulogy/nulogy_graphql_api"
  spec.license = "MIT"

  spec.metadata = {
    "homepage_uri" => "https://github.com/nulogy/nulogy_graphql_api",
    "changelog_uri" => "https://github.com/nulogy/nulogy_graphql_api/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/nulogy/nulogy_graphql_api",
    "bug_tracker_uri" => "https://github.com/nulogy/nulogy_graphql_api/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "graphql", "~> 2.3"
  spec.add_dependency "graphql-schema_comparator", "~> 1.2"
  spec.add_dependency "rails", ">= 7.0", "< 8.1"
  spec.add_dependency "rainbow", "~> 3.1"

  spec.add_development_dependency "appraisal", "~> 2.5"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rspec-rails", ">= 6.1"
  spec.add_development_dependency "rubocop", "~> 1.67"
  spec.add_development_dependency "rubocop-performance", "~> 1.22"
  spec.add_development_dependency "rubocop-rails", "~> 2.26"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 3.1"
  spec.add_development_dependency "rubocop-rspec_rails", "~> 2.3"
end
