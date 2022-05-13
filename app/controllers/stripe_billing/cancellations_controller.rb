module StripeBilling
  class CancellationsController < ApplicationController
    include AfterCommitEverywhere

    before_action :prepare_provisioning_key

    def create
      ActiveRecord::Base.transaction do
        @provisioning_key.update!(flagged_for_cancellation: :true)
        after_commit { ManuallyCancelActiveProvisioningKeyJob.perform_later(@provisioning_key) }
      end

      respond_to do |format|
        format.html { redirect_to plan_path }
        # format.turbo_stream { render turbo_stream: turbo_stream.replace("payment_element", partial: "spinner") }
      end
    end

    def destroy
      ActiveRecord::Base.transaction do
        @provisioning_key.update!(flagged_for_cancellation: :false)
        after_commit { ManuallyReactivateProvisioningKeyJob.perform_later(@provisioning_key) }
      end

      respond_to do |format|
        format.html { redirect_to plan_path }
        # format.turbo_stream { render turbo_stream: turbo_stream.replace("payment_element", partial: "spinner") }
      end
    end

    private

    def prepare_provisioning_key
      @provisioning_key = current_billing_party.provisioning_keys.active&.first
    end
  end
end
