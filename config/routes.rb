StripeBilling::Engine.routes.draw do
  root to: "plans#show"

  resource :webhooks, only: [:create]

  resource :plan, only: [:show, :new, :create] do
    resource :payment, only: [:show, :destroy] do
      get :confirm
    end

    resource :cancel, only: [:create, :destroy], controller: :cancellations
  end
end
