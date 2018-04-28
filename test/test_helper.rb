ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true iff a test user is logged in
  def is_logged_in?
  	!session[:user_id].nil?
  end

  # Log in a test user
  def log_in_user(user, password)
  	post login_path, params: { session: { email: user.email, password: password } }
  	follow_redirect!
  	# assert_template 'users/show'
  end

  # Log out a test user
  def log_out_user()
    delete logout_path
  end
end
