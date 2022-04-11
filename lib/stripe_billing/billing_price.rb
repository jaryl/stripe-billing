module StripeBilling
  class BillingPrice
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::AttributeAssignment

    attr_accessor :id, :product_id

    delegate :nickname, :type, :active, :livemode, :currency, :unit_amount, :unit_amount_decimal, to: :stripe_price

    def created_at
      Time.at(stripe_price.created).utc
    end

    def updated_at
      Time.at(stripe_price.updated).utc
    end

    def build
      stripe_price
      self.freeze
    end

    private

    def stripe_price
      @stripe_price ||= Stripe::Price.retrieve(id, { product: product_id })
    end
  end
end
