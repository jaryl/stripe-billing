Rails.application.routes.draw do
  root to: "dashboard#show"
  mount StripeBilling::Engine => "/stripe_billing"
end
