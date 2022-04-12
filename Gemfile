source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in stripe_billing.gemspec.
gemspec

group :development, :test do
  # A Ruby gem to load environment variables from `.env`.
  gem "dotenv-rails"
  # A PostgreSQL client library for Ruby
  gem "pg", "~> 1.3.1"
  # Sprockets Rails integration
  gem "sprockets-rails"
  # Ruby on Rails Logtail integration
  gem "logtail-rails", "~> 0.1.6"
end

group :test do
  # RSpec for Rails 5+
  gem "rspec-rails", "~> 5.0.0"
  # Simple one-liner tests for common Rails functionality
  gem "shoulda-matchers", "~> 5.0"
  # A library for setting up Ruby objects as test data
  gem "factory_bot_rails"
  # Library for stubbing and setting expectations on HTTP requests in Ruby
  gem "webmock"
  # Brings back `assigns` and `assert_template` to your Rails tests
  gem "rails-controller-testing"
  # A library for generating fake data such as names, addresses, and phone numbers
  gem "faker"
end
