module StripeBilling
  class NewSubscriptionForm
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :plan
    attr_reader :provisioning_record

    validates :plan, presence: true

    def initialize(billing_party, params = {})
      @billing_party = billing_party
      @provisioning_record = billing_party.provisioning_records.build
      super(params)
    end

    def submit
      if valid?
        provisioning_record.save!
        # TODO: background job for creating customer record, and subscription
        # TODO: abstract out job runner to allow sync vs async
        # TODO: allow for price not plane to be selected
        return true
      end

      false
    end

    private

    attr_reader :billing_party
  end
end