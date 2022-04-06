StripeBilling.setup do |config|
  config.error_reporter = ->(error, **kwargs) {
    puts error.inspect if Rails.env.development?
  }
end
