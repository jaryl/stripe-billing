# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_11_042517) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "provisioning_key_status", ["pending", "active", "expired", "failed", "cancelled"]

  create_table "accounts", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feature_set_key"
    t.jsonb "feature_set_overrides", default: {}, null: false
  end

  create_table "stripe_billing_events", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "api_version", null: false
    t.datetime "generated_at", null: false
    t.boolean "livemode", default: false
    t.string "object_type", null: false
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_billing_provisioning_keys", force: :cascade do |t|
    t.string "billable_type"
    t.bigint "billable_id"
    t.enum "status", default: "pending", null: false, enum_type: "provisioning_key_status"
    t.boolean "flagged_for_cancellation", default: false, null: false
    t.string "plan_key", null: false
    t.string "price_key", null: false
    t.datetime "stripe_current_period_end"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.string "stripe_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billable_type", "billable_id"], name: "index_stripe_billing_provisioning_keys_on_billable"
    t.index ["billable_type", "billable_id"], name: "index_stripe_billing_provisioning_keys_on_billable_unique", unique: true, where: "(status = ANY (ARRAY['pending'::provisioning_key_status, 'active'::provisioning_key_status]))"
  end

end
