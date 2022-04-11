class CreateStripeBillingProvisioningKeys < ActiveRecord::Migration[7.0]
  def change
    create_enum "provisioning_key_status", ["pending", "active", "expired"]

    create_table :stripe_billing_provisioning_keys do |t|
      t.references :billable, polymorphic: true, index: true

      t.enum :status, enum_type: :provisioning_key_status, default: "pending", null: false
      t.boolean :flagged_for_cancellation, null: false, default: false

      t.string :stripe_customer_id
      t.string :stripe_subscription_id

      t.timestamps

      t.index [:billable_type, :billable_id], unique: true, where: "status IN ('pending', 'active')", name: "index_stripe_billing_provisioning_keys_on_billable_unique"
    end
  end
end
