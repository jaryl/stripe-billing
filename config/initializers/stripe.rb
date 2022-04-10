Stripe.set_app_info(
  'StripeBilling',
  version: StripeBilling::VERSION,
  url: 'https://github.com/jaryl/stripe-billing'
)

Stripe.api_version = ENV["STRIPE_API_VERSION"]
Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

Stripe.enable_telemetry = ENV["STRIPE_TELEMETRY"] == "true"
