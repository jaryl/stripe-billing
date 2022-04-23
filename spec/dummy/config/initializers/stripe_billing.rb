StripeBilling.setup do |config|
  config.logger = Rails.logger.tagged("stripe-billing")

  config.error_reporter = ->(error, **kwargs) {
    StripeBilling.logger.error "[#{error.class}] #{error.message}", error: error
    error.backtrace.each do |line|
      StripeBilling.logger.error line
    end
  }
end

Rails.configuration.to_prepare do
  StripeBilling.feature_sets(:accounts) do
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

  StripeBilling.billing_plans(:accounts) do
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
    process "invoice.payment_succeeded", with: "default_payment_method_for_stripe_subscription"
    process "customer.subscription.updated", with: "cancel_provisioning_key"
    process "customer.subscription.created", "customer.subscription.updated", with: "activate_provisioning_key"
  end
end
