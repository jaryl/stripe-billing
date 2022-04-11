module StripeBilling
  module FeatureSetConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def has_feature_set(**options)
        options[:accessor] ||= :feature_set
        options[:key] ||= :feature_set_key
        options[:overrides] ||= :feature_set_overrides

        define_method(options[:accessor]) do
          @feature_set ||= StripeBilling::FeatureSet.with(
            key: send(options[:key]),
            overrides: send(options[:overrides]),
          )
        end
      end
    end
  end
end
