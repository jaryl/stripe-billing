class CreateStripeBillingProvisioningKeys < ActiveRecord::Migration[7.0]
  def up
    create_enum "provisioning_key_status", ["pending", "active", "expired", "failed", "cancelled"]

    create_table :stripe_billing_provisioning_keys do |t|
      t.references :billable, polymorphic: true, index: true

      t.enum :status, enum_type: :provisioning_key_status, default: "pending", null: false

      t.boolean :flagged_for_cancellation, null: false, default: false

      t.string :plan_key, null: false
      t.string :price_key, null: false

      t.datetime :stripe_current_period_end

      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      t.string :stripe_product_id

      t.timestamps

      t.index [:billable_type, :billable_id], unique: true, where: "status IN ('pending', 'active')", name: "index_stripe_billing_provisioning_keys_on_billable_unique"
    end

    def down
      drop_table :stripe_billing_provisioning_keys

      execute <<-SQL
        DROP TYPE provisioning_key_status;
      SQL
    end
  end
end
