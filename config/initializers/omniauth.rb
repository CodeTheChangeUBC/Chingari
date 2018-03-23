Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"]
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET']
end