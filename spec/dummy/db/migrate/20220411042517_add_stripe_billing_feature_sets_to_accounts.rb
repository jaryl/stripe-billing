class AddStripeBillingFeatureSetsToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :feature_set_key, :string
    add_column :accounts, :feature_set_overrides, :jsonb, null: false, default: {}
  end
end
