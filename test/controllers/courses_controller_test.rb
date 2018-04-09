require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest

    def setup
        @user = User.create(name: "Courses user", email: "user@courses.ca", password: "coursebar", password_confirmation: "coursebar", role: Role.admin)
        log_in_user(@user, "coursebar")
    end

    def teardown
        log_out_user()
    end

    test "should get index" do
        get courses_path
        assert_response :success
    end

    test "should get review" do
        get courses_review_path
        assert_response :success
    end

    test "should get drafts" do
        get courses_drafts_path
        assert_response :success
    end

    test "should get published" do
        get courses_published_path
        assert_response :success
    end

    test "should get new" do
        get courses_new_path
        assert_response :success
    end

    test "should get a single edit course" do
        get "/courses/314/edit"
        assert_response :success
    end

    test "should get single course" do
        get "/courses/314"
        assert_response :success
    end
end
