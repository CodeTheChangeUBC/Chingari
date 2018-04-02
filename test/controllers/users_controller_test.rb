require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

	def setup 
		@user = User.new(name: "user1", email: "user@users.ca", 
						password: "password", password_confirmation: "password")
		@user.save
	end

	test "should get index" do
		get users_path
		assert_response :success
	end

	test "should get new" do
		get new_user_path
		assert_response :success
	end

	test "should get new via signup route" do 
		get signup_path
		assert_response :success
		assert_template 'users/new'
	end

	test "should get user show" do 
		get user_path(@user)
		assert_response :success
		assert_template 'users/show'
	end

end
