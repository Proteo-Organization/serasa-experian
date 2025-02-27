# frozen_string_literal: true

require_relative "lib/serasa_experian/version"

Gem::Specification.new do |spec|
  spec.name = "serasa_experian"
  spec.version = SerasaExperian::VERSION
  spec.authors = ["CarlosHenriqueSM05"]
  spec.email = ["carlos.henrique@nullbug.dev"]

  spec.summary = "Serasa"
  spec.description = "Serasa API integration gem"
  spec.homepage = "https://github.com/Null-Bug-Company/serasa-experian"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday'
  spec.add_dependency 'rails'
  spec.add_dependency 'rspec'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'securerandom'
  spec.add_dependency 'webmock'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
