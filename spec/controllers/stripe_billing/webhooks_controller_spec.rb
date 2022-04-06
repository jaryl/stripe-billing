require 'rails_helper'

module StripeBilling
  RSpec.describe WebhooksController, type: :controller do
    routes { Engine.routes }

    describe "POST #create" do
      before { post :create }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end

