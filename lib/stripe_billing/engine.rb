module StripeBilling
  class Engine < ::Rails::Engine
    isolate_namespace StripeBilling

    config.to_prepare do
      ActiveRecord::Base.include(FeatureSetConcern)

      StripeBilling.billing_party.class_eval do
        has_feature_set
        has_many :provisioning_keys, as: :billable, class_name: "StripeBilling::ProvisioningKey"
      end
    end

    initializer "stripe-billing.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb") unless Rails.env.test?
    end
  end
end
