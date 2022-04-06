require 'rails_helper'

module StripeBilling
  RSpec.describe WebhooksController, type: :controller do
    routes { Engine.routes }

    describe "POST #create" do
      context "with valid payload" do
        let(:raw_event) do
          {
            "id" => "evt_3KlYo1HRcyv3PAxT0lrIkzfC",
            "created" => 1649251313,
            "api_version" => "2020-08-27",
            "type" => "payment_intent.created",
            "data" => {},
          }
        end
        before { allow(Stripe::Webhook).to receive(:construct_event).and_return(raw_event) }
        before { post :create }

        it { expect(assigns(:event)).to be_persisted }
        it { expect(response).to have_http_status(:ok) }
      end

      context "with invalid payload" do
        before { allow(Stripe::Webhook).to receive(:construct_event).and_raise(JSON::ParserError) }
        before { post :create }

        it { expect(assigns(:event)).to be_nil }
        it { expect(response).to have_http_status(:bad_request) }
      end

      context "with invalid signature" do
        before { allow(Stripe::Webhook).to receive(:construct_event).and_raise(Stripe::SignatureVerificationError.new("", "")) }
        before { post :create }

        it { expect(assigns(:event)).to be_nil }
        it { expect(response).to have_http_status(:bad_request) }
      end
    end
  end
end

