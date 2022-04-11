FactoryBot.define do
  factory :provisioning_key, class: "StripeBilling::ProvisioningKey" do
    billable { association :account }
  end
end
