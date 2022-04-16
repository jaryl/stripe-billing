module StripeBilling
  class FeatureSet
    attr_reader :features

    delegate :each, to: :features

    def self.with(key:, overrides: {})
      original_feature_set = StripeBilling.feature_sets[key || :default]
      return original_feature_set if overrides.empty?

      overrides.inject(original_feature_set.deep_dup) do |feature_set, (key, values)|
        feature_set.feature(key, **values).freeze
        feature_set
      end.build
    end

    def feature(key, **kwargs)
      feature_class = "#{key}_feature".camelize.safe_constantize
      features[key] = feature_class.new(**kwargs)
    end

    def build
      features.each { |_, value| value.build }
      features.freeze
      self.freeze
    end

    private

    def initialize
      @features = {}
    end

    def initialize_dup(source)
      @features = source.features.deep_dup
    end
  end
end
