class Tier
  # List of content tiers
  # This is meant to support various monetization plans
  # Eg. upgrade user to a new tier to access new content

  def Tier.free
    0
  end

  def Tier.premium
    1
  end
end