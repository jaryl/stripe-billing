class Account < ApplicationRecord
  has_many :provisioning_records, as: :billable, class_name: "StripeBilling::ProvisioningRecord"
end
