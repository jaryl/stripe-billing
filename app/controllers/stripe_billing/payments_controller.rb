module StripeBilling
  class PaymentsController < ApplicationController
    before_action :redirect_if_no_pending_provisioning_key, only: [:show, :confirm]
    before_action :redirect_if_already_active_provisioning_key, only: :show
    before_action :redirect_if_no_payment_intent_provided, only: :confirm

    def show
    end

    def confirm
    end

    private

    def provisioning_key
      @provisioning_key ||= current_billing_party.provisioning_keys.not_expired&.first
    end

    def redirect_if_no_pending_provisioning_key
      redirect_to new_plan_path if provisioning_key.blank?
    end

    def redirect_if_already_active_provisioning_key
      redirect_to plan_path if provisioning_key.active?
    end

    def redirect_if_no_payment_intent_provided
      if params[:payment_intent].blank?
        redirect_to plan_path
      elsif provisioning_key.stripe_subscription.latest_invoice.payment_intent.id != params[:payment_intent]
        redirect_to plan_path
      end
    end
  end
end
