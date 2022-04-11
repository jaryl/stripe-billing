StripeBilling.setup do |config|
  config.error_reporter = ->(error, **kwargs) {
    Rails.logger.error error.message, error: error if Rails.env.development?
  }

  config.logger = ActiveSupport::TaggedLogging.new(Rails.logger).tagged("stripe-billing")
end

Rails.configuration.after_initialize do
  StripeBilling.feature_sets do
    feature_set :default do
      feature :restricted_access, zone: "public"
    end

    feature_set :premium_plan do
      feature :restricted_access, zone: "*"
    end
  end
end
