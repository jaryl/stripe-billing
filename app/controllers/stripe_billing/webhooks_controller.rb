module StripeBilling
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      @event = Event.create_with(event_params).find_or_create_by!(external_id: raw_stripe_event.id)
      # TODO: process stripe event with background job
      head :ok
    rescue JSON::ParserError, Stripe::SignatureVerificationError, ActiveRecord::RecordInvalid => error
      StripeBilling.error_reporter.call(error, tags: ["stripe", "webhooks"])
      head :bad_request
    end

    private

    def raw_stripe_event
      return @raw_stripe_event if defined?(@raw_stripe_event)

      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      webhook_secret = ENV["STRIPE_WEBHOOK_SECRET"]

      @raw_stripe_event = OpenStruct.new(Stripe::Webhook.construct_event(payload, sig_header, webhook_secret).to_h)
    end

    def event_params
      {
        external_id: raw_stripe_event.id,
        api_version: raw_stripe_event.api_version,
        generated_at: Time.at(raw_stripe_event.created).utc,
        livemode: raw_stripe_event.livemode,
        object_type: raw_stripe_event.type,
        data: JSON.parse(raw_stripe_event.data.to_json),
      }
    end
  end
end
