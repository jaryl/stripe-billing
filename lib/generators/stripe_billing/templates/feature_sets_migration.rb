class AddStripeBillingFeatureSetsTo<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :<%= table_name %>, :feature_set_key, :string
    add_column :<%= table_name %>, :feature_set_overrides, :jsonb, null: false, default: {}
  end
end
