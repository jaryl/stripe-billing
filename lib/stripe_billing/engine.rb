module StripeBilling
  class Engine < ::Rails::Engine
    isolate_namespace StripeBilling

    config.to_prepare do
      ActiveRecord::Base.include(FeatureSetConcern)
    end
  end
end
