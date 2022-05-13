require 'rails_helper'

module StripeBilling
  RSpec.describe CancellationsController, type: :controller do
    routes { Engine.routes }

    before { ActiveJob::Base.queue_adapter = :test }
    before { create(:provisioning_key, status: :active) }

    describe "POST #create" do
      before { post :create }

      it { expect(assigns(:provisioning_key)).to be_flagged_for_cancellation }
      it { expect(ManuallyCancelActiveProvisioningKeyJob).to have_been_enqueued.with(assigns(:provisioning_key)) }
      it { expect(response).to redirect_to(plan_path) }
    end

    describe "DELETE #destroy" do
      before { delete :destroy }

      it { expect(assigns(:provisioning_key)).not_to be_flagged_for_cancellation }
      it { expect(ManuallyReactivateProvisioningKeyJob).to have_been_enqueued.with(assigns(:provisioning_key)) }
      it { expect(response).to redirect_to(plan_path) }
    end
  end
end
