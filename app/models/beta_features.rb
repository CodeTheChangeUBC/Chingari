class BetaFeatures
  # This is a config file to help track and release features
  # To track a feature, wrap off of your changes in a condition and register your feature name under the @@features table

  # Example wrapper:
  # if BetaFeatures.released?(:name_of_my_feature, current_user: current_user)
  #   ... all of my cool new code ...
  # end

  # Example registration:
  # @@features = {
  #   ... other features ...
  #   name_of_my_feature: :development
  #   ... other features ...
  # }

  # Enabling your feature to public:
  # @@features = {
  #   ... other features ...
  #   name_of_my_feature: :released
  #   ... other features ...
  # }

  # Note that beta features are visible in non-production environments, as well as to admin users
  
  @@features = {
    oauth: :development,
    static_pages: :development,
    released_feature: :released
  }

  def self.released?(feature, current_user: nil)
    return true if Rails.env != "production"
    return true if !current_user.nil? && current_user.role == Roles.admin
    return true if @@features[feature] == :released
    return false
  end
end