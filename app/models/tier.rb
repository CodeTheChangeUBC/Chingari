class Tier
  # List of content tiers
  # This is meant to support various monetization plans
  # Eg. upgrade user to a new tier to access new content

  def self.free
    0
  end

  def self.premium
    1
  end
end