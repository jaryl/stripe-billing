require "rails/generators/active_record"

module StripeBilling
  module Generators
    class FeatureSetsGenerator < ActiveRecord::Generators::Base
      include Rails::Generators::Migration

      namespace "stripe_billing:feature_sets"
      desc "Migration for adding feature set columns to target model"

      source_root File.expand_path("../templates", __FILE__)

      def copy_migration
        migration_template "feature_sets_migration.rb", "db/migrate/add_stripe_billing_feature_sets_to_#{table_name.downcase}.rb"
      end

      def migration_version
        return unless ActiveRecord.version >= Gem::Version.new("5.0")
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end
  end
end
