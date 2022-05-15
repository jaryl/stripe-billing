module StripeBilling
  class WebhookHandlers::FlagProvisioningKeyForCancellationJob < ApplicationJob
    queue_as :default

    def perform(event)
      return if event.data.dig("object", "cancel_at_period_end") != true
      return if event.data.dig("previous_attributes", "cancel_at_period_end") == true

      provisioning_key_gid = event.data.dig("object", "metadata", "provisioning_key_gid")
      provisioning_key = GlobalID::Locator.locate_signed(provisioning_key_gid)

      provisioning_key.update!(flagged_for_cancellation: true)

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
