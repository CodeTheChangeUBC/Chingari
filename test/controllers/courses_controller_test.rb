require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest

    def setup
        @user = User.create(id: 1, name: "new user", email: "user@user.ca", password: "foobar", password_confirmation: "foobar", role: 10)
        log_in_user("user@user.ca", "foobar")
        @course = Course.new(title: "Test Course", user_id: 1, description: "Test Description is this one", visibility: 0, tier: 0)
    end

    test "should get index" do
        get courses
        assert_response :success
    end

    test "should get review" do
        get courses_review
        assert_response :success
    end

    test "should get drafts" do
        get courses_drafts
        assert_response :success
    end

    test "should get published" do
        get courses_published
        assert_response :success
    end

    test "should get new" do
        get courses_new
        assert_response :success
    end

    test "should get edit course" do
        get edit_course
        assert_response :success
    end

    test "should get single course" do
        get course/1
        assert_response :success
    end
end
