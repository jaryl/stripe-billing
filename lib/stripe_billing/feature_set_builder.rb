module StripeBilling
  class FeatureSetBuilder
    def initialize
      @feature_sets = HashWithIndifferentAccess.new { |hash, key| hash[key] = FeatureSet.send(:new) }
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

    attr_reader :feature_sets
  end
end
