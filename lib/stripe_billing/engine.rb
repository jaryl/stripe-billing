module StripeBilling
  class Engine < ::Rails::Engine
    isolate_namespace StripeBilling

    config.to_prepare do
      ActiveRecord::Base.include(FeatureSetConcern)
      # raise FeatureSetConcern.inspect
    end

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
      g.helper false
      g.assets false
      g.view_specs false
      g.request_specs false
      g.controller_specs true
    end
  end
end
