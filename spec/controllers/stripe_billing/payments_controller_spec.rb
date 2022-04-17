require 'rails_helper'

module StripeBilling
  RSpec.describe PaymentsController, type: :controller do
    routes { Engine.routes }

    let(:account) { create(:account) }

    before { account }

    context "with pending provisioning key" do
      before { create(:provisioning_key, billable: account, status: :pending) }

      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_key)).to be_pending }
        it { expect(response).to render_template(:show) }
      end

      describe "GET #confirm" do
        context "with url params" do
          before { get :confirm, params: { payment_intent: "something" } }

          it { expect(assigns(:provisioning_key)).to be_pending }
          it { expect(response).to render_template(:confirm) }
        end

        context "with no url params" do
          before { get :confirm }

          it { expect(assigns(:provisioning_key)).to be_pending }
          it { expect(response).to redirect_to(plan_path) }
        end
      end
    end

    context "with active provisioning key" do
      before { create(:provisioning_key, billable: account, status: :active) }

      describe "GET #show" do
        before { get :show }
        it { expect(response).to redirect_to(plan_path) }
      end

      describe "GET #confirm" do
        before { get :confirm }
        it { expect(response).to redirect_to(plan_path) }
      end
    end

    context "with no provisioning key" do
      describe "GET #show" do
        before { get :show }
        it { expect(response).to redirect_to(new_plan_path) }
      end

      describe "GET #confirm" do
        before { get :confirm }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end
  end
end
