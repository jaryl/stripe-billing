module StripeBilling
  class BillingPlan
    include ActiveModel::AttributeAssignment

    attr_accessor :id
    attr_reader :feature_set, :billing_prices

    delegate :name, :description, :active, :livemode, to: :stripe_product

    def provisions(key)
      @feature_set ||= StripeBilling.feature_sets[key]
    end

    def price(key, **kwargs)
      billing_prices[key] = BillingPrice.new(kwargs.merge(product_id: id))
    end

    def build
      stripe_product
      billing_prices.each { |_, value| value.build }
      self.freeze
    end

    private

    attr_reader :feature_set_key

    def initialize
      @billing_prices = HashWithIndifferentAccess.new
    end

    def stripe_product
      @stripe_product ||= Stripe::Product.retrieve(id)
    end
  end
end
