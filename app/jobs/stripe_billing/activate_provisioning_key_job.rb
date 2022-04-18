module StripeBilling
  class ActivateProvisioningKeyJob < ApplicationJob
    queue_as :default

    def perform(event)
      return if event.data.dig("object", "status") != "active"

      provisioning_key_gid = event.data.dig("object", "metadata", "provisioning_key_gid")
      provisioning_key = GlobalID::Locator.locate_signed(provisioning_key_gid)

      stripe_product_id = event.data.dig("object", "plan", "product")

      ActiveRecord::Base.transaction do
        provisioning_key.update!({
          status: :active,
          stripe_product_id: stripe_product_id,
        })

        provisioning_key.billable.update!(feature_set_key: provisioning_key.billing_plan.feature_set.key)
      end
    end
  end
end
