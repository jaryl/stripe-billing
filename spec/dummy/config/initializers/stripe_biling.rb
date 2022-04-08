StripeBilling.setup do |config|
  config.error_reporter = ->(error, **kwargs) {
    Rails.logger.error error.message, error: error if Rails.env.development?
  }

  config.logger = ActiveSupport::TaggedLogging.new(Rails.logger).tagged("stripe-billing")
end
