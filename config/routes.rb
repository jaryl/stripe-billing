StripeBilling::Engine.routes.draw do
  resource :webhooks, only: [:create]

  resource :plan, only: [:show, :new, :create, :destroy] do
    resource :payment, only: [:show] do
      get :confirm
    end
  end
end
