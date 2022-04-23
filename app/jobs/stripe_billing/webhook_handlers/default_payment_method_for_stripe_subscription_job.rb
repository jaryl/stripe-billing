module StripeBilling
  class WebhookHandlers::DefaultPaymentMethodForStripeSubscriptionJob < ApplicationJob
    queue_as :default

    def perform(event)
      return if event.data.dig("object", "billing_reason") != "subscription_create"

      stripe_subscription_id = event.data.dig("object", "subscription")
      stripe_payment_intent_id = event.data.dig("object", "payment_intent")

      stripe_payment_intent = Stripe::PaymentIntent.retrieve(stripe_payment_intent_id)

      Stripe::Subscription.update(
        stripe_subscription_id,
        default_payment_method: stripe_payment_intent.payment_method
      )
    end
  end
end
