Rails.application.routes.draw do
  mount StripeBilling::Engine => "/stripe_billing"
end
