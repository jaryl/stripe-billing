module StripeBilling
  class WebhookHandlers::CancelProvisioningKeyJob < ApplicationJob
    queue_as :default

    def perform(event)
      return if event.data.dig("object", "status") != "incomplete_expired"
      return if event.data.dig("previous_attributes", "status") != "incomplete"

      provisioning_key_gid = event.data.dig("object", "metadata", "provisioning_key_gid")
      provisioning_key = GlobalID::Locator.locate_signed(provisioning_key_gid)

      return if provisioning_key.cancelled?

      provisioning_key.update!(status: :cancelled)

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
