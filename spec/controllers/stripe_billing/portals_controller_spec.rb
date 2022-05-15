require 'rails_helper'

module StripeBilling
  RSpec.describe PortalsController, type: :controller do
    routes { Engine.routes }

    let!(:account) { create(:account) }

    describe "POST #create" do
      let(:billing_portal_session) { double(url: "https://billing.stripe.com/session/test_123") }
      before { allow(Stripe::BillingPortal::Session).to receive(:create).and_return(billing_portal_session) }

      context "with current provisioning key" do
        let!(:provisioning_key) { create(:provisioning_key, billable: account, status: :active) }

        before { post :create }

        it { expect(assigns(:provisioning_key)).to be_present }
        it { expect(response).to redirect_to(billing_portal_session.url) }
      end

      context "with no provisioning key" do
        before { post :create }

        it { expect(assigns(:provisioning_key)).to be_blank }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end

  end
end
