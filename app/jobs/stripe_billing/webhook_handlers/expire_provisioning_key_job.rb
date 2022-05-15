module StripeBilling
  class WebhookHandlers::ExpireProvisioningKeyJob < ApplicationJob
    queue_as :default

    def perform(event)
      return if event.data.dig("object", "status") != "incomplete_expired"
      return if event.data.dig("previous_attributes", "status") != "incomplete"

      provisioning_key_gid = event.data.dig("object", "metadata", "provisioning_key_gid")
      provisioning_key = GlobalID::Locator.locate_signed(provisioning_key_gid)

      ActiveRecord::Base.transaction do
        provisioning_key.update!(status: :expired)
      end

      Turbo::StreamsChannel.broadcast_stream_to(
        [provisioning_key.billable, provisioning_key],
        content: ApplicationController.render(
          :turbo_stream,
          partial: "stripe_billing/payments/redirect",
        )
      )
    end
  end
end
