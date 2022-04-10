class CreateStripeBillingProvisioningRecords < ActiveRecord::Migration[7.0]
  def change
    create_enum "provisioning_record_status", ["pending", "active", "expired"]

    create_table :stripe_billing_provisioning_records do |t|
      t.references :billable, polymorphic: true, index: true

      t.enum :status, enum_type: :provisioning_record_status, default: "pending", null: false
      t.boolean :renewable, null: false, default: true

      t.string :stripe_customer_id
      t.string :stripe_subscription_id

      t.timestamps

      t.index [:billable_type, :billable_id], unique: true, where: "status IN ('pending', 'active')", name: "index_stripe_billing_provisioning_records_on_billable_unique"
    end
  end
end
