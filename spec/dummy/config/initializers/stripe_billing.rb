StripeBilling.setup do |config|
  config.error_reporter = ->(error, **kwargs) {
    Rails.logger.error error.message, error: error if Rails.env.development?
  }

  config.logger = ActiveSupport::TaggedLogging.new(Rails.logger).tagged("stripe-billing")
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
    billing_plan :basic_plan, id: "prod_LTU1h9mzsL0cwX" do
      provisions :basic_features
      price :monthly, id: "price_1KmX3qHRcyv3PAxT0DFNSEsL"
      # price :annual
    end

    billing_plan :premium_plan, id: "prod_LTU2D5Sv8YHkeQ" do
      provisions :premium_features
      price :monthly, id: "price_1KmX4KHRcyv3PAxTZBpxIcSn"
      # price :annual
    end
  end
end
