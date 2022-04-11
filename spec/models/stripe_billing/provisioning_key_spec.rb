require 'rails_helper'

module StripeBilling
  RSpec.describe ProvisioningKey, type: :model do
    it { is_expected.to belong_to(:billable) }
  end
end
