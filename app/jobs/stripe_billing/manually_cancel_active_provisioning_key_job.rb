module StripeBilling
  class ManuallyCancelActiveProvisioningKeyJob < ApplicationJob
    queue_as :default

    def perform(provisioning_key)
      return if !provisioning_key.active?

      Stripe::Subscription.update(
        provisioning_key.stripe_subscription_id,
        { cancel_at_period_end: true },
      )
    end
  end
end
