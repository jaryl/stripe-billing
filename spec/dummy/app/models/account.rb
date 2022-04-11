class Account < ApplicationRecord
  has_many :provisioning_keys, as: :billable, class_name: "StripeBilling::ProvisioningKey"
end
