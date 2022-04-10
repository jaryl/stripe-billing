StripeBilling::Engine.routes.draw do
  resource :webhooks, only: [:create]

  resource :plan, only: [:show, :new, :create, :destroy] do
    # resource :portal, only: [:create]
  end
end
