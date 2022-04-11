module StripeBilling
  class FeatureSet
    attr_reader :features

    def self.with(key:, overrides: {})
      original_feature_set = StripeBilling.feature_sets[key || :default]
      return original_feature_set if overrides.empty?

      new_feature_set = overrides.inject(original_feature_set.deep_dup) do |feature_set, (key, values)|
        feature_set.feature(key, **values)
        feature_set
      end

      new_feature_set.features.freeze
      new_feature_set.freeze
    end

    def feature(key, **kwargs)
      feature_class = "#{key}_feature".camelize.safe_constantize
      features[key] = feature_class.new(**kwargs).freeze
    end

    def initialize_dup(source)
      @features = source.features.deep_dup
    end

    private

    def initialize
      @features = {}
    end
  end
end
