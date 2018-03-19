Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "1003482777633-up7f5pjbkd0joh0egucdotcm1p92q0c5.apps.googleusercontent.com", "dT5zqPAyoSqy2cEQmDCu1cS6"
end