StripeBilling.setup do |config|
  config.billing_party_class = "Account"

  config.logger = Rails.logger.tagged("stripe-billing")

  config.error_reporter = ->(error, **kwargs) {
    StripeBilling.logger.error error.message, error: error
  }
end

Rails.configuration.after_initialize do
  StripeBilling.feature_sets do
    feature_set :default do
      feature :restricted_access, zone: ""
    end

    feature_set :basic_features do
      feature :restricted_access, zone: "members"
    end

    feature_set :premium_features do
      feature :restricted_access, zone: "priority"
    end
  end

  StripeBilling.billing_plans do
    billing_plan :basic_plan, id: ENV["SAMPLE_BASIC_PLAN_ID"] do
      provisions :basic_features
      price :monthly, id: ENV["SAMPLE_BASIC_PLAN_MONTHLY_PRICE_ID"]
      price :annual, id: ENV["SAMPLE_BASIC_PLAN_ANNUAL_PRICE_ID"]
    end

    billing_plan :premium_plan, id: ENV["SAMPLE_PREMIUM_PLAN_ID"] do
      provisions :premium_features
      price :monthly, id: ENV["SAMPLE_PREMIUM_PLAN_MONTHLY_PRICE_ID"]
      price :annual, id: ENV["SAMPLE_PREMIUM_PLAN_ANNUAL_PRICE_ID"]
    end
  end

  StripeBilling.webhooks do
    process "invoice.payment_succeeded", with: StripeBilling::DefaultPaymentMethodForStripeSubscriptionJob
    process "customer.subscription.created", "customer.subscription.updated", "customer.subscription.deleted", with: StripeBilling::ActivateProvisioningKeyJob
  end
end
