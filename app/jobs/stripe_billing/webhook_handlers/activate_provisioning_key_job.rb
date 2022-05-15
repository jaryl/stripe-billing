module StripeBilling
  class WebhookHandlers::ActivateProvisioningKeyJob < ApplicationJob
    queue_as :default

    def perform(event)
      return if event.data.dig("object", "status") != "active"

      provisioning_key_gid = event.data.dig("object", "metadata", "provisioning_key_gid")
      provisioning_key = GlobalID::Locator.locate_signed(provisioning_key_gid)

      # TODO: raise if provisioning key is not pending

      stripe_product_id = event.data.dig("object", "plan", "product")
      stripe_current_period_end = Time.at(event.data.dig("object", "current_period_end")).utc

      ActiveRecord::Base.transaction do
        provisioning_key.update!(
          status: :active,
          stripe_current_period_end: stripe_current_period_end,
          stripe_product_id: stripe_product_id,
          flagged_for_cancellation: false,
        )
        provisioning_key.billable.update!(feature_set_key: provisioning_key.billing_plan.feature_set.key)
      end
    end
  end
end
