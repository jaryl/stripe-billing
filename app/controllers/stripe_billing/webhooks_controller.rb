module StripeBilling
  class WebhooksController < ApplicationController
    def create
      render json: {}, status: :ok
    end
  end
end
