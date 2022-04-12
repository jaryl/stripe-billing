require "stripe_billing/version"
require "stripe_billing/engine"
require "stripe_billing/errors"

require "stripe_billing/feature"
require "stripe_billing/feature_set"
require "stripe_billing/feature_set_builder"

require "stripe_billing/billing_price"
require "stripe_billing/billing_plan"
require "stripe_billing/billing_plan_builder"

require "stripe"

module StripeBilling
  mattr_accessor :error_reporter
  mattr_accessor :logger

  class << self
    def setup
      yield self
    end

    def billing_plans(&block)
      return @@billing_plans if defined?(@@billing_plans)

      builder = BillingPlanBuilder.new
      builder.instance_eval(&block) if block.present?

      @@billing_plans = builder.build
    end

    def feature_sets(&block)
      return @@feature_sets if defined?(@@feature_sets)

      builder = FeatureSetBuilder.new
      builder.instance_eval(&block) if block.present?

      @@feature_sets = builder.build
    end
  end

  class Engine < ::Rails::Engine
  end
end
