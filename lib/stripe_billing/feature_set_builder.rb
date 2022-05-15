module StripeBilling
  class FeatureSetBuilder
    def initialize(billing_party_type)
      @billing_party_type = billing_party_type
      @feature_sets = HashWithIndifferentAccess.new { |hash, key| hash[key] = FeatureSet.send(:new, key, billing_party_type) }
    end

    def feature_set(key, &block)
      feature_set = feature_sets[key]
      feature_set.instance_eval(&block) if block.present?
    end

    def build
      feature_sets.inject(HashWithIndifferentAccess.new) do |acc, (key, value)|
        acc[key] = value.build
        acc
      end.freeze
    end

    private

    attr_reader :feature_sets, :billing_party_type
  end
end
