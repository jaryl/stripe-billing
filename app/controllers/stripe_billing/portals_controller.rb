module StripeBilling
  class PortalsController < ApplicationController
    before_action :prepare_provisioning_key

    def create
      billing_portal_session = Stripe::BillingPortal::Session.create({
        customer: @provisioning_key.stripe_customer_id,
        return_url: main_app.root_url(anchor: "billing"),
      })

      redirect_to billing_portal_session.url, allow_other_host: true
    end

    private

    def prepare_provisioning_key
      @provisioning_key = current_billing_party.provisioning_keys.find_by(status: [:active, :pending])
      redirect_to new_plan_path if @provisioning_key.blank?
    end
  end
end
