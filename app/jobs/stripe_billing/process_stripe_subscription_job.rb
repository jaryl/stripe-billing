module StripeBilling
  class ProcessStripeSubscriptionJob < ApplicationJob
    include Turbo::Streams::StreamName

    queue_as :default

    def perform(provisioning_key, stripe_price_id)
      return if !provisioning_key.pending?

      if provisioning_key.stripe_customer_id.blank?
        stripe_customer = generate_stripe_customer!(billing_party: provisioning_key.billable)
        provisioning_key.update!(stripe_customer_id: stripe_customer.id)
      end

      if provisioning_key.stripe_subscription_id.blank?
        stripe_subscription = generate_stripe_subscription!(
          provisioning_key: provisioning_key,
          stripe_price_id: stripe_price_id,
        )
        provisioning_key.update!(stripe_subscription_id: stripe_subscription.id)
      end

      Turbo::StreamsChannel.broadcast_stream_to(
        [provisioning_key.billable, provisioning_key],
        content: ApplicationController.render(
          :turbo_stream,
          partial: "stripe_billing/payments/provisioning_key",
          locals: { provisioning_key: provisioning_key },
        )
      )
    end

    private

    def generate_stripe_customer!(billing_party:)
      Stripe::Customer.create(
        email: billing_party.email,
        metadata: { billing_party_gid: billing_party.to_sgid(expires_in: nil).to_s },
      )
    end

    def generate_stripe_subscription!(provisioning_key:, stripe_price_id:)
      Stripe::Subscription.create(
        customer: provisioning_key.stripe_customer_id,
        items: [{ price: stripe_price_id }],
        payment_behavior: "default_incomplete",
        expand: ["latest_invoice.payment_intent"],
        metadata: { provisioning_key_gid: provisioning_key.to_sgid(expires_in: nil).to_s },
      )
    end
  end
end
