# frozen_string_literal: true

require_relative "lib/inova_reverse_geocoder/version"

Gem::Specification.new do |spec|
  spec.name = "inova_reverse_geocoder"
  spec.version = InovaReverseGeocoder::VERSION
  spec.authors = ["Omar Elsamahy"]
  spec.email = ["omarelsamahy109@gmail.com"]

  spec.summary = "Reverese Google Geocoder"
  spec.description = "a google geocoder that returns city and country of lat and long"
  spec.homepage = "https://github.com/OmarElsamahy/inova_reverse_geocoder"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/OmarElsamahy/inova_reverse_geocoder"
  spec.metadata["changelog_uri"] = "https://github.com/OmarElsamahy/inova_reverse_geocoder/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob("{lib}/**/*", File::FNM_DOTMATCH)
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'net-http'
  spec.add_dependency 'json', '>= 2.5', '< 3.0'
  spec.add_dependency "rails", ">= 6.1.7"
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
