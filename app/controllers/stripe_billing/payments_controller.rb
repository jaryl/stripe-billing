module StripeBilling
  class PaymentsController < ApplicationController
    include AfterCommitEverywhere

    before_action :redirect_if_no_pending_provisioning_key, only: [:show, :destroy, :confirm]
    before_action :redirect_if_already_active_provisioning_key, only: [:show, :destroy]
    before_action :redirect_if_no_payment_intent_provided, only: :confirm

    def show
    end

    def confirm
    end

    def destroy
      ActiveRecord::Base.transaction do
        provisioning_key.update!(flagged_for_cancellation: :true)
        after_commit { ManuallyCancelPendingProvisioningKeyJob.perform_later(provisioning_key) }
      end

      respond_to do |format|
        format.html { redirect_to plan_payment_path }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("payment_element", partial: "spinner") }
      end
    end

    private

    def provisioning_key
      @provisioning_key ||= current_billing_party.provisioning_keys.where(status: [:active, :pending])&.first
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
