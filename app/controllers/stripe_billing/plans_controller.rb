module StripeBilling
  class PlansController < ApplicationController
    before_action :redirect_if_current_plan_exists, only: [:new, :create]
    before_action :redirect_if_no_current_plan, only: [:show, :destroy]

    def show
    end

    def new
      @form = NewSubscriptionForm.new(current_billing_party)
      @provisioning_key = ProvisioningKey.new
    end

    def create
      @form = NewSubscriptionForm.new(current_billing_party, new_subscription_form_params)
      if @form.submit
        redirect_to plan_path
      else
        render :new
      end
    end

    def destroy
      @provisioning_key.update!(flagged_for_cancellation: true)
      redirect_to new_plan_path
    end

    private

    def provisioning_key
      @provisioning_key ||= current_billing_party.provisioning_keys.not_expired&.first
    end

    def redirect_if_current_plan_exists
      redirect_to plan_path if provisioning_key.present?
    end

    def redirect_if_no_current_plan
      redirect_to new_plan_path if provisioning_key.blank?
    end

    def new_subscription_form_params
      params.require(:new_subscription_form).permit(:plan)
    end
  end
end
