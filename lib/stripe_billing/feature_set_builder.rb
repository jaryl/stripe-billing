module StripeBilling
  class FeatureSetBuilder
    attr_reader :feature_sets

    delegate :[], to: :feature_sets

    def initialize
      @feature_sets = ActiveSupport::HashWithIndifferentAccess.new { |hash, key| hash[key] = FeatureSet.send(:new) }
    end

    def feature_set(key, &block)
      feature_set = feature_sets[key]
      feature_set.instance_eval(&block) if block.present?
      feature_set.features.freeze
      feature_set.freeze
    end
  end
end
