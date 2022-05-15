require 'rails_helper'

module StripeBilling
  RSpec.describe PaymentsController, type: :controller do
    routes { Engine.routes }

    before { ActiveJob::Base.queue_adapter = :test }

    let(:account) { create(:account) }

    before { account }

    context "with pending provisioning key" do
      let(:payment_intent) { SecureRandom.uuid }

      before { create(:provisioning_key, billable: account, status: :pending) }
      before { allow_any_instance_of(StripeBilling::ProvisioningKey).to receive_message_chain(:stripe_subscription, :latest_invoice, :payment_intent, :id) { payment_intent } }

      describe "GET #show" do
        before { get :show }

        it { expect(assigns(:provisioning_key)).to be_pending }
        it { expect(response).to render_template(:show) }
      end

      describe "GET #confirm" do
        context "with valid url params" do
          before { get :confirm, params: { payment_intent: payment_intent } }

          it { expect(assigns(:provisioning_key)).to be_pending }
          it { expect(response).to render_template(:confirm) }
        end

        context "with invalid url params" do
          before { get :confirm, params: { payment_intent: "invalid-value" } }
          it { expect(response).to redirect_to(plan_path) }
        end
      end

      describe "DELETE #destroy" do
        before { delete :destroy }

        it { expect(assigns(:provisioning_key)).to be_flagged_for_cancellation }
        it { expect(ManuallyCancelPendingProvisioningKeyJob).to have_been_enqueued.with(assigns(:provisioning_key)) }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end

    context "with active provisioning key" do
      let(:payment_intent) { SecureRandom.uuid }

      before { create(:provisioning_key, billable: account, status: :active) }
      before { allow_any_instance_of(StripeBilling::ProvisioningKey).to receive_message_chain(:stripe_subscription, :latest_invoice, :payment_intent, :id) { payment_intent } }

      describe "GET #show" do
        before { get :show }
        it { expect(response).to redirect_to(plan_path) }
      end

      describe "GET #confirm" do
        context "with valid url params" do
          before { get :confirm, params: { payment_intent: payment_intent } }

          it { expect(assigns(:provisioning_key)).to be_active }
          it { expect(response).to render_template(:confirm) }
        end

        context "with invalid url params" do
          before { get :confirm, params: { payment_intent: "invalid-value" } }
          it { expect(response).to redirect_to(plan_path) }
        end
      end

      describe "DELETE #destroy" do
        before { delete :destroy }

        it { expect(assigns(:provisioning_key)).not_to be_flagged_for_cancellation }
        it { expect(ManuallyCancelPendingProvisioningKeyJob).not_to have_been_enqueued.with(assigns(:provisioning_key)) }
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

      describe "DELETE #destroy" do
        before { delete :destroy }
        it { expect(response).to redirect_to(new_plan_path) }
      end
    end
  end
end
