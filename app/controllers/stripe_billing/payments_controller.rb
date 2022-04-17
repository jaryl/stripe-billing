module StripeBilling
  class PaymentsController < ApplicationController
    before_action :redirect_if_no_pending_provisioning_key
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
      if provisioning_key.blank?
        redirect_to new_plan_path
      elsif provisioning_key.active?
        redirect_to plan_path
      end
    end

    def redirect_if_no_payment_intent_provided
      redirect_to plan_path if params[:payment_intent].blank?
    end
  end
end
