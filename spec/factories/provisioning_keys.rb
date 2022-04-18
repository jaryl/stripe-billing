FactoryBot.define do
  factory :provisioning_key, class: "StripeBilling::ProvisioningKey" do
    billable { association :account }

    plan_key { :basic_plan }
    price_key { :monthly }
  end
end
