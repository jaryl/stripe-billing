FactoryBot.define do
  factory :provisioning_record, class: "StripeBilling::ProvisioningRecord" do
    billable { association :account }
  end
end
