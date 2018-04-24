class Tier
  # List of content tiers
  # This is meant to support various monetization plans
  # Eg. upgrade user to a new tier to access new content

  def self.schema
    {
      free: 0,
      premium: 1
    }
  end

  def self.free
    Tier.schema[:free]
  end

  def self.premium
    Tier.schema[:premium]
  end
end