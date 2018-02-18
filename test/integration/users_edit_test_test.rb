require 'test_helper'

class UsersEditTestTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:user1)
  	@user2 = users(:user2)
  end

  test "should not access edit if not logged in" do 
  	get edit_user_path(@user)
  	follow_redirect!
  	assert_template "static_pages/home"
  end

  test "should not delete user if not logged in" do 
  	assert_no_difference 'User.count' do 
  		delete user_path(@user)
  	end
  end

  test "should not access edit if logged in as different user" do 
  	log_in_user(@user2, "password")
  	get edit_user_path(@user)
  	follow_redirect!
  	assert_template 'static_pages/home'
  end

  test "should not delete user if logged in as different user" do 
  	log_in_user(@user2, "password")
  	assert_no_difference 'User.count' do 
  		delete user_path(@user)
  	end
  end

  test "should successfully edit user" do 
  	new_email = "new@email.ca" 
  	log_in_user(@user2, "password")
  	patch user_path(@user2), params: {
  		user: {
  			email: new_email
  		}
  	}
  	@user2.reload
  	assert_equal @user2.email, new_email
  end

end
