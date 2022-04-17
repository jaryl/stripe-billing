module StripeBilling
  class ProvisioningKey < ApplicationRecord
    enum status: {
      pending: "pending",
      active: "active",
      expired: "expired",
      failed: "failed",
    }

    belongs_to :billable, polymorphic: true

    def client_secret
      @client_secret ||= stripe_subscription.latest_invoice.payment_intent.client_secret
    end

    def ordered_at
      Time.at(stripe_subscription.created).utc
    end

    delegate :items, to: :stripe_subscription
    delegate :latest_invoice, to: :stripe_subscription

    def stripe_customer
      @stripe_customer ||= Stripe::Customer.retrieve({
        id: stripe_customer_id,
        expand: [],
      })
    end

    def stripe_subscription
      @stripe_subscription ||= Stripe::Subscription.retrieve({
        id: stripe_subscription_id,
        expand: ['latest_invoice.payment_intent'],
      })
    end

    def stripe_product
      @stripe_product ||= Stripe::Product.retrieve({
        id: stripe_product_id,
        expand: [],
      })
    end
  end
end
