require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup 
  	@user = User.new(name: "new user", email: "user@user.ca", 
  					password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do 
  	assert @user.valid?
  end

  test "name should be present" do 
  	@user.name = ""
  	assert_not @user.valid?
  end

  test "email should be present" do 
  	@user.email = ""
  	assert_not @user.valid?
  end

  test "email should have valid format" do 
  	invalid_emails = ["email", "email@invalid", "email@email."]
  	invalid_emails.each do |addr| 
  		@user.email = addr
  		assert_not @user.valid?
  	end
  end

  test "email addresses should be unique" do 
  	second_user = @user.dup
  	second_user.email = @user.email.upcase
  	@user.save
  	assert_not second_user.valid?
  end

  test "email should be saved as lowercase" do 
  	mixed_case_email = "mixED@cASE.coM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal @user.email, mixed_case_email.downcase
  end

  test "password should be non-blank" do 
  	@user.password = @user.password_confirmation = ""
  	@user.save
  	assert_not @user.valid?
  end

  test "password should have minimum length 6" do 
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

  test "password should have maximum length 6" do 
  	@user.password = @user.password_confirmation = "a" * 256
  	assert_not @user.valid?
  end

end
