module StripeBilling
  class ManuallyCancelPendingProvisioningKeyJob < ApplicationJob
    queue_as :default

    discard_on Stripe::InvalidRequestError

    def perform(provisioning_key)
      return if provisioning_key.cancelled?

      Stripe::Subscription.delete(provisioning_key.stripe_subscription_id)
    end
  end
end
