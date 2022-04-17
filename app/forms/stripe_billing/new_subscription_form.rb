module StripeBilling
  class NewSubscriptionForm
    include ActiveModel::Model
    include ActiveModel::Validations
    include AfterCommitEverywhere

    attr_accessor :plan_key, :price_key
    attr_reader :provisioning_key

    validates :plan_key, :price_key, presence: true
    validate :billing_party_must_be_valid
    validate :selected_price_must_be_valid

    def initialize(billing_party, params = {})
      @billing_party = billing_party
      @provisioning_key = billing_party.provisioning_keys.build
      super(params)
    end

    def submit
      if valid?
        ActiveRecord::Base.transaction do
          # TODO: re-use existing customer if same currency provisioning_key.stripe_customer_id = ...
          provisioning_key.save!
          after_commit { ProcessStripeSubscriptionJob.perform_later(provisioning_key, selected_price.id) }
        end

        return true
      end
      false
    end

    def available_plans
      @available_plans ||= StripeBilling.billing_plans
    end

    def selected_price
      @selected_price ||= StripeBilling.billing_plans[plan_key].billing_prices[price_key]
    end

    private

    attr_reader :billing_party

    def billing_party_must_be_valid
      errors.add(:billing_party, "Something went wrong") if billing_party.blank?
    end

    def selected_price_must_be_valid
      errors.add(:selected_price, "Something went wrong") if selected_price.blank?
    end
  end
end
