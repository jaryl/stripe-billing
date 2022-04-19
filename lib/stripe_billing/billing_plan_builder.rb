module StripeBilling
  class BillingPlanBuilder
    def initialize(billing_party_type)
      @billing_party_type = billing_party_type
      @billing_plans = HashWithIndifferentAccess.new { |hash, key| hash[key] = BillingPlan.send(:new, billing_party_type) }
    end

    def billing_plan(key, **kwargs, &block)
      billing_plan = billing_plans[key]
      billing_plan.attributes = kwargs
      billing_plan.instance_eval(&block) if block.present?
    end

    def build
      billing_plans.inject(HashWithIndifferentAccess.new) do |acc, (key, value)|
        acc[key] = value.build
        acc
      end.freeze
    end

    private

    attr_reader :billing_plans, :billing_party_type
  end
end
