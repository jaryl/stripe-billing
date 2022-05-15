StripeBilling::Engine.routes.draw do
  root to: "plans#show"

  resource :portal, only: [:create]

  resource :webhooks, only: [:create]

  resource :plan, only: [:show, :new, :create] do
    resource :payment, only: [:show, :destroy] do
      get :confirm
    end
  end
end
