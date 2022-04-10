class ApplicationController < ActionController::Base
  def current_billing_party
    @current_billing_party = Account.first
  end
end
