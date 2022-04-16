class RestrictedAccessFeature < StripeBilling::Feature
  attr_accessor :zone

  def to_s
    "Exclusive access to #{zone} zone"
  end
end
