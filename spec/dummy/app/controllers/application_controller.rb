class ApplicationController < ActionController::Base
  helper_method :current_billing_party

  private

  def current_billing_party
    @current_billing_party = Account.first
  end
end
