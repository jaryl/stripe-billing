require "stripe_billing/version"
require "stripe_billing/engine"
require "stripe_billing/errors"

require "stripe_billing/feature"
require "stripe_billing/feature_set"
require "stripe_billing/feature_set_builder"

require "stripe"
require "logtail-rails"

module StripeBilling
  mattr_accessor :error_reporter
  mattr_accessor :logger

  class << self
    def setup
      yield self
    end

    def feature_sets(&block)
      @@builder ||= FeatureSetBuilder.new
      @@builder.instance_eval(&block) if block.present?
      @@builder.freeze
    end
  end

  class Engine < ::Rails::Engine
  end
end
