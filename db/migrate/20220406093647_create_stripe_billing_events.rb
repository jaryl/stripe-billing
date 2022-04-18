class CreateStripeBillingEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :stripe_billing_events do |t|
      t.string :external_id, null: false, unique: true

      t.string :api_version, null: false
      t.datetime :generated_at, null: false
      t.boolean :livemode, default: false

      t.string :object_type, null: false
      t.jsonb :data, null: false

      t.timestamps
    end
  end
end
