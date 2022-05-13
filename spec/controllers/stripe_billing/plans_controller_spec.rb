require 'rails_helper'

module StripeBilling
  RSpec.describe PlansController, type: :controller do
    routes { Engine.routes }

    let(:account) { create(:account) }
    let(:form) { double }

    before { account }
    before { allow(NewSubscriptionForm).to receive(:new).and_return(form) }

    context "with no provisioning record" do
      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_key)).to be_blank }
        it { expect(response).to redirect_to(new_plan_path) }
      end

      describe "GET #new" do
        before { get :new }

        it { expect(assigns(:provisioning_key)).to be_new_record }
        it { expect(response).to render_template(:new) }
      end

      describe "POST #create" do
        before { allow(form).to receive(:submit).and_return(return_value) }
        before { allow(form).to receive(:provisioning_key).and_return(build_stubbed(:provisioning_key)) }

        before { post :create, params: { new_subscription_form: params } }

        context "with valid params" do
          let(:params) { { plan: "basic_plan" } }
          let(:return_value) { true }

          it { expect(assigns(:provisioning_key)).to be_persisted }
          it { expect(response).to redirect_to(plan_path) }
        end

        context "with invalid params" do
          let(:params) { { plan: "" } }
          let(:return_value) { false }

          it { expect(assigns(:provisioning_key)).to be_blank }
          it { expect(response).to render_template(:new) }
        end
      end
    end

    context "with pending provisioning record" do
      before { create(:provisioning_key, billable: account, status: :pending) }

      describe "GET #show" do
        before { get :show }
        it { expect(response).to redirect_to(plan_payment_path) }
      end

      describe "GET #new" do
        before { get :new }
        it { expect(response).to redirect_to(plan_payment_path) }
      end

      describe "POST #create" do
        before { post :create }
        it { expect(response).to redirect_to(plan_payment_path) }
      end
    end

    context "with active provisioning record" do
      before { create(:provisioning_key, billable: account, status: :active) }

      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_key)).to be_present }
        it { expect(response).to render_template(:show) }
      end

      describe "GET #new" do
        before { get :new }

        it { expect(assigns(:provisioning_key)).to be_persisted }
        it { expect(response).to redirect_to(plan_path) }
      end

      describe "POST #create" do
        before { post :create }

        it { expect(assigns(:provisioning_key)).to be_persisted }
        it { expect(response).to redirect_to(plan_path) }
      end
    end

    context "with expired provisioning record" do
      before { create(:provisioning_key, billable: account, status: :expired) }

      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_key)).to be_blank }
        it { expect(response).to redirect_to(new_plan_path) }
      end

      describe "GET #new" do
        before { get :new }

        it { expect(assigns(:provisioning_key)).to be_new_record }
        it { expect(response).to render_template(:new) }
      end

      describe "POST #create" do
        before { allow(form).to receive(:submit).and_return(return_value) }
        before { allow(form).to receive(:provisioning_key).and_return(build_stubbed(:provisioning_key)) }

        before { post :create, params: { new_subscription_form: params } }

        context "with valid params" do
          let(:params) { { plan: "basic_plan" } }
          let(:return_value) { true }

          it { expect(assigns(:provisioning_key)).to be_persisted }
          it { expect(response).to redirect_to(plan_path) }
        end

        context "with invalid params" do
          let(:params) { { plan: "" } }
          let(:return_value) { false }

          it { expect(assigns(:provisioning_key)).to be_blank }
          it { expect(response).to render_template(:new) }
        end
      end
    end
  end
end
