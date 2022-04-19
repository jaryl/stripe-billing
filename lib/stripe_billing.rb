require "turbo-rails"
require "stripe"
require "after_commit_everywhere"

require "stripe_billing/version"
require "stripe_billing/engine"
require "stripe_billing/errors"

require "stripe_billing/feature"
require "stripe_billing/feature_set"
require "stripe_billing/feature_set_builder"

require "stripe_billing/billing_price"
require "stripe_billing/billing_plan"
require "stripe_billing/billing_plan_builder"

require "stripe_billing/webhooks_builder"

module StripeBilling
  mattr_accessor :error_reporter
  mattr_accessor :logger

  mattr_accessor :billing_party_types, default: []

  mattr_reader :billing_plans
  mattr_reader :feature_sets

  class << self
    def setup
      yield self
    end

    def billing_plans(billing_party_type, &block)
      @@billing_plans ||= HashWithIndifferentAccess.new

      @@billing_party_types ||= []
      @@billing_party_types << billing_party_type
      @@billing_party_types.uniq!

      return @@billing_plans[billing_party_type] if @@billing_plans.include?(billing_party_type)

      builder = BillingPlanBuilder.new(billing_party_type)
      builder.instance_eval(&block) if block.present?

      @@billing_plans[billing_party_type] = builder.build
    end


    def feature_sets(billing_party_type, &block)
      @@feature_sets ||= HashWithIndifferentAccess.new

      @@billing_party_types ||= []
      @@billing_party_types << billing_party_type
      @@billing_party_types.uniq!

      return @@feature_sets[billing_party_type] if @@feature_sets.include?(billing_party_type)

      builder = FeatureSetBuilder.new(billing_party_type)
      builder.instance_eval(&block) if block.present?

      @@feature_sets[billing_party_type] = builder.build
    end

    def webhooks(&block)
      return @@webhooks if defined?(@@webhooks)

      builder = WebhooksBuilder.new
      builder.instance_eval(&block) if block.present?

      @@webhooks = builder.build
    end
  end

  class Engine < ::Rails::Engine
  end
end
