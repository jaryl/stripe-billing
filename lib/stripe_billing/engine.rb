module StripeBilling
  class Engine < ::Rails::Engine
    isolate_namespace StripeBilling

    ActiveSupport::Reloader.to_prepare do
      ActiveRecord::Base.include(FeatureSetConcern)
      StripeBilling.billing_party_types.each do |type|
        type.to_s.classify.safe_constantize.class_eval do
          has_feature_set
          has_many :provisioning_keys, as: :billable, class_name: "StripeBilling::ProvisioningKey"
        end
      end
    end

    config.after_initialize do
      ActiveRecord::Base.include(FeatureSetConcern)
      StripeBilling.billing_party_types.each do |type|
        type.to_s.classify.safe_constantize.class_eval do
          has_feature_set
          has_many :provisioning_keys, as: :billable, class_name: "StripeBilling::ProvisioningKey"
        end
      end
    end

    initializer "stripe-billing.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb") unless Rails.env.test?
    end
  end
end
