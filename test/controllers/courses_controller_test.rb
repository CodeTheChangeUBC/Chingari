require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest

    def setup
        @user_admin = User.create(name: "Courses Admin", email: "admin@courses.ca", password: "passwwd", password_confirmation: "passwwd", role: Role.admin)
        @user_mod = User.create(name: "Courses Mod", email: "mod@courses.ca", password: "passwwd", password_confirmation: "passwwd", role: Role.moderator)
        @user_std = User.create(id: 99, name: "Courses user", email: "user@courses.ca", password: "passwwd", password_confirmation: "passwwd")
    end

    def teardown
        log_out_user()
    end

    test "admin user get index" do
        log_in_user(@user_admin, "passwwd")
        get courses_path
        assert_response :success
    end

    test "standard user get index" do
        log_in_user(@user_std, "passwwd")
        get courses_path
        assert_response :redirect
    end

    test "admin user get review" do
        log_in_user(@user_admin, "passwwd")
        get courses_review_path
        assert_response :success
    end

    test "standard user get review" do
        log_in_user(@user_std, "passwwd")
        get courses_review_path
        assert_response :redirect
    end

    test "standard user get drafts" do
        log_in_user(@user_std, "passwwd")
        get courses_drafts_path
        assert_response :success
    end

    test "standard user get published" do
        log_in_user(@user_std, "passwwd")
        get courses_published_path
        assert_response :success
    end

    test "standard user get new" do
        log_in_user(@user_std, "passwwd")
        get courses_new_path
        assert_response :success
    end

    test "admin user get edit course 314" do
        log_in_user(@user_admin, "passwwd")
        get "/courses/314/edit"
        assert_response :success
    end

    test "standard user get edit course 314" do
        log_in_user(@user_std, "passwwd")
        get "/courses/314/edit"
        assert_response :redirect
    end

    test "standard user get course 314" do
        log_in_user(@user_std, "passwwd")
        get "/courses/314"
        assert_response :success
    end

    test "standard user successfully post new" do
        log_in_user(@user_std, "passwwd")
        post "/courses", params: { course: { title: "New Course A", user_id: 2, description: "Test Description is New", visibility: 0, tier: 0 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal true, response['status']
    end

    test "standard user unsuccessfully post new" do
        log_in_user(@user_std, "passwwd")
        post "/courses", params: { course: { title: "New Course B", user_id: 2, description: "Test Description is New", visibility: 2, tier: 0 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal false, response['status']
    end

    test "admin user successfully post new" do
        log_in_user(@user_admin, "passwwd")
        post "/courses", params: { course: { title: "New Course C", user_id: 2, description: "Test Description is New", visibility: 2, tier: 0 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal true, response['status']
    end

    test "admin user unsuccessfully post new" do
        log_in_user(@user_admin, "passwwd")
        post "/courses", params: { course: { title: "New Course D", user_id: 2, description: "Test Description is New", visibility: 5, tier: 46 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal false, response['status']
    end

    test "standard user successfully put updated" do
        log_in_user(@user_std, "passwwd")
        put "/courses/416", params: { course: { title: "Updated Course A", user_id: 2, description: "Test Description is Updated", visibility: 0, tier: 0 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal true, response['status']
    end

    test "standard user unsuccessfully put updated" do
        log_in_user(@user_std, "passwwd")
        put "/courses/416", params: { course: { title: "Updated Course B", user_id: 2, description: "Test Description is Updated", visibility: 2, tier: 0 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal false, response['status']
    end

    test "unauthorized standard user unsuccessfully put updated" do
        log_in_user(@user_std, "passwwd")
        put "/courses/314", params: { course: { title: "Updated Course B", user_id: 2, description: "Test Description is Updated", visibility: 2, tier: 0 } }
        assert_response :redirect
    end

    test "admin user successfully put updated" do
        log_in_user(@user_admin, "passwwd")
        put "/courses/314", params: { course: { title: "Updated Course C", user_id: 2, description: "Test Description is Updated", visibility: 2, tier: 0 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal true, response['status']
    end

    test "admin user unsuccessfully put updated" do
        log_in_user(@user_admin, "passwwd")
        put "/courses/314", params: { course: { title: "Updated Course D", user_id: 2, description: "Test Description is Updated", visibility: 5, tier: 46 } }
        assert_response :success

        response = JSON.parse(@response.body)
        assert_equal false, response['status']
    end

    test "standard user successfully delete" do
        log_in_user(@user_std, "passwwd")
        get courses_new_path
        assert_response :success
        response = JSON.parse(@response.body)
        cid = response['course']['id'].to_s

        put "/courses/"+cid, params: { course: { title: "Deleteable", user_id: 99, description: "Test Description please ignore", visibility: 0, tier: 0 } }
        assert_response :success

        get "/courses/"+cid
        assert_response :success

        delete "/courses/"+cid
        assert_response :success

        get "/courses/"+cid
        assert_response :missing       
    end

    test "unauthorized standard user unsuccessfully delete" do
        log_in_user(@user_std, "passwwd")
        delete "/courses/314"
        assert_response :redirect
    end

    test "admin user successfully delete" do
        log_in_user(@user_admin, "passwwd")
        get courses_new_path
        assert_response :success
        response = JSON.parse(@response.body)
        cid = response['course']['id'].to_s

        put "/courses/"+cid, params: { course: { title: "Deleteable", user_id: 99, description: "Test Description please ignore", visibility: 2, tier: 0 } }
        assert_response :success

        get "/courses/"+cid
        assert_response :success

        delete "/courses/"+cid
        assert_response :success

        get "/courses/"+cid
        assert_response :missing  
    end
end
