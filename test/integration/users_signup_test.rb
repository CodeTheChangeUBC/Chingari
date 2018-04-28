require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "should not sign up invalid user" do 
  	get new_user_path
  	assert_no_difference 'User.count' do
  		post users_path, params: { 
  			user: { 
  				name: "",
  				email: "invalid",
  				password: "pass",
  				password_confirmation: "word"
  			}
  		}
  	end
  	assert_template 'users/new'
  end

  test "should signup a valid user" do 
  	get new_user_path
  	assert_difference 'User.count', 1 do 
  		post users_path, params: {
  			user: {
  				name: "bella bib",
  				email: "bella@gmail.ca",
  				password: "foobaz",
  				password_confirmation: "foobaz"
  			}
  		}
  	end
  	follow_redirect!
  	# assert_template 'users/show'
    assert is_logged_in?
  end
end
