require 'rails_helper'

module StripeBilling
  RSpec.describe PlansController, type: :controller do
    routes { Engine.routes }

    let(:account) { create(:account) }

    before { account }

    context "with no provisioning record" do
      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_record)).to be_blank }
        it { expect(response).to redirect_to(new_plan_path) }
      end

      describe "GET #new" do
        before { get :new }

        it { expect(assigns(:provisioning_record)).to be_new_record }
        it { expect(response).to render_template(:new) }
      end

      describe "POST #create" do
        before { post :create, params: { new_subscription_form: params } }

        context "with valid params" do
          let(:params) { { plan: "basic_plan" } }
          it { expect(assigns(:form)).to be_valid }
          it { expect(response).to redirect_to(plan_path) }
        end

        context "with invalid params" do
          let(:params) { { plan: "" } }
          it { expect(assigns(:form)).not_to be_valid }
          it { expect(response).to render_template(:new) }
        end
      end

      describe "DELETE #destroy" do
        before { delete :destroy }

        it { expect(assigns(:provisioning_record)).to be_blank }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end

    context "with pending provisioning record" do
      before { create(:provisioning_record, billable: account, status: :pending) }

      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_record)).to be_present }
        it { expect(response).to render_template(:show) }
      end

      describe "GET #new" do
        before { get :new }

        it { expect(assigns(:provisioning_record)).to be_persisted }
        it { expect(response).to redirect_to(plan_path) }
      end

      describe "POST #create" do
        before { post :create }

        it { expect(assigns(:provisioning_record)).to be_persisted }
        it { expect(response).to redirect_to(plan_path) }
      end

      describe "DELETE #destroy" do
        before { delete :destroy }

        it { expect(assigns(:provisioning_record).renewable?).to eq(false) }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end

    context "with active provisioning record" do
      before { create(:provisioning_record, billable: account, status: :active) }

      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_record)).to be_present }
        it { expect(response).to render_template(:show) }
      end

      describe "GET #new" do
        before { get :new }

        it { expect(assigns(:provisioning_record)).to be_persisted }
        it { expect(response).to redirect_to(plan_path) }
      end

      describe "POST #create" do
        before { post :create }

        it { expect(assigns(:provisioning_record)).to be_persisted }
        it { expect(response).to redirect_to(plan_path) }
      end

      describe "DELETE #destroy" do
        before { delete :destroy }

        it { expect(assigns(:provisioning_record).renewable?).to eq(false) }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end

    context "with expired provisioning record" do
      before { create(:provisioning_record, billable: account, status: :expired) }

      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_record)).to be_blank }
        it { expect(response).to redirect_to(new_plan_path) }
      end

      describe "GET #new" do
        before { get :new }

        it { expect(assigns(:provisioning_record)).to be_new_record }
        it { expect(response).to render_template(:new) }
      end

      # TODO: create here

      describe "DELETE #destroy" do
        before { delete :destroy }

        it { expect(assigns(:provisioning_record)).to be_blank }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end
  end
end
