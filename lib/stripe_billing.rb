require "stripe_billing/version"
require "stripe_billing/engine"
require "stripe_billing/errors"

require "stripe"
require "logtail-rails"

module StripeBilling
  mattr_accessor :error_reporter
  mattr_accessor :logger

  def self.setup
    yield self
  end

  class Engine < ::Rails::Engine
  end
end
