StripeBilling.setup do |config|
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
    billing_plan :basic_plan, id: "prod_LTU1h9mzsL0cwX" do
      provisions :basic_features
      price :monthly, id: "price_1KmX3qHRcyv3PAxT0DFNSEsL"
      price :annual, id: "price_1Kp7OgHRcyv3PAxTl9RTuoKK"
    end

    billing_plan :premium_plan, id: "prod_LTU2D5Sv8YHkeQ" do
      provisions :premium_features
      price :monthly, id: "price_1KmX4KHRcyv3PAxTZBpxIcSn"
      price :annual, id: "price_1Kp7PIHRcyv3PAxTOjg3LIQw"
    end
  end
end
