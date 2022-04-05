require_relative "lib/stripe_billing/version"

Gem::Specification.new do |spec|
  spec.name        = "stripe_billing"
  spec.version     = StripeBilling::VERSION
  spec.authors     = ["Jaryl Sim"]
  spec.email       = ["jaryl.sim@me.com"]
  spec.homepage    = "https://github.com/jaryl/stripe-billing"
  spec.summary     = "Lorem ipsum."
  spec.description = "Lorem ipsum."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jaryl/stripe-billing"
  spec.metadata["changelog_uri"] = "https://github.com/jaryl/stripe-billing"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.2"
end
