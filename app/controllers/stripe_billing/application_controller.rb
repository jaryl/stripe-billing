module StripeBilling
  class ApplicationController < ::ApplicationController
    skip_before_action(:verify_authenticity_token) if protect_from_forgery.any?
  end
end
