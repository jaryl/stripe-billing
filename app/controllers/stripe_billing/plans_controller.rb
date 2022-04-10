module StripeBilling
  class PlansController < ApplicationController
    before_action :redirect_if_current_plan_exists, only: [:new, :create]
    before_action :redirect_if_no_current_plan, only: [:show, :destroy]

    def show
    end

    def new
      @form = NewSubscriptionForm.new(current_billing_party)
      @provisioning_record = ProvisioningRecord.new
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
      @provisioning_record.update!(renewable: false)
      redirect_to new_plan_path
    end

    private

    def provisioning_record
      @provisioning_record ||= current_billing_party.provisioning_records.not_expired&.first
    end

    def redirect_if_current_plan_exists
      redirect_to plan_path if provisioning_record.present?
    end

    def redirect_if_no_current_plan
      redirect_to new_plan_path if provisioning_record.blank?
    end

    def new_subscription_form_params
      params.require(:new_subscription_form).permit(:plan)
    end
  end
end
