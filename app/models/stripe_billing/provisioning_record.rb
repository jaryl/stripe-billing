module StripeBilling
  class ProvisioningRecord < ApplicationRecord
    enum status: {
      pending: "pending",
      active: "active",
      expired: "expired",
    }

    belongs_to :billable, polymorphic: true
  end
end
