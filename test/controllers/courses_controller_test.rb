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


    # ########################################################################
    # Tests for get /courses

    test "admin user get index" do
        log_in_user(@user_admin, "passwwd")
        get courses_path
        assert_response :ok
    end

    test "standard user get index" do
        log_in_user(@user_std, "passwwd")
        get courses_path
        assert_response :ok  # Unauthorized
    end

    test "no user get index" do
        get courses_path
        assert_response :ok
    end

    # test "admin user get review" do
    #     log_in_user(@user_admin, "passwwd")
    #     get courses_review_path
    #     assert_response :ok

    #     response = JSON.parse(@response.body)
    #     response["result"].each do |course|
    #         assert_equal Visibility.reviewing, course['visibility'].to_i
    #     end
    # end


    # ########################################################################
    # Tests for get /courses/review

    # test "standard user get review" do
    #     log_in_user(@user_std, "passwwd")
    #     get courses_review_path
    #     assert_response :unauthorized  # Unauthorized
    # end

    # test "no user get review" do
    #     get courses_review_path
    #     assert_response :unauthorized
    # end


    # # ########################################################################
    # # Tests for get /courses/drafts

    # test "standard user get drafts" do
    #     log_in_user(@user_std, "passwwd")
    #     get courses_drafts_path
    #     assert_response :ok

    #     response = JSON.parse(@response.body)
    #     response["result"].each do |course|
    #         assert_equal Visibility.draft, course["visibility"].to_i
    #     end
    # end

    # test "no user get drafts" do
    #     get courses_drafts_path
    #     assert_response :unauthorized
    # end


    # ########################################################################
    # Tests for get /courses/published

    # test "standard user get published" do
    #     log_in_user(@user_std, "passwwd")
    #     get courses_published_path
    #     assert_response :ok

    #     response = JSON.parse(@response.body)
    #     response["result"].each do |course|
    #         assert_equal Visibility.published, course["visibility"].to_i
    #     end
    # end

    # test "no user get published" do
    #     get courses_published_path
    #     assert_response :ok

    #     response = JSON.parse(@response.body)
    #     response["result"].each do |course|
    #         assert_equal Visibility.published, course["visibility"].to_i
    #     end
    # end


    # ########################################################################
    # Tests for get /courses/new

    test "admin user get new" do
        log_in_user(@user_admin, "passwwd")
        get courses_new_path
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal @user_admin.id, response["result"]["user_id"].to_i
        assert_not_nil response["schema"]["visibility"]["published"]
        assert_not_nil response["schema"]["visibility"]["reviewing"]
    end

    test "standard user get new" do
        log_in_user(@user_std, "passwwd")
        get courses_new_path
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal @user_std.id, response["result"]["user_id"].to_i
        assert_nil response["schema"]["visibility"]["published"]
        assert_nil response["schema"]["visibility"]["reviewing"]
    end

    test "no user get new" do
        get courses_new_path
        assert_response :unauthorized
    end


    # ########################################################################
    # Tests for get /courses/:course_id/edit

    test "admin user get edit course 314" do
        log_in_user(@user_admin, "passwwd")
        get "/courses/314/edit"
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 314, response["result"]["id"]
        assert_not_nil response["schema"]["visibility"]["published"]
        assert_not_nil response["schema"]["visibility"]["reviewing"]
    end

    test "standard user get edit course 314" do
        log_in_user(@user_std, "passwwd")
        get "/courses/314/edit"
        assert_response :unauthorized  # Unauthorized
    end

    test "no user get edit course 314" do
        get "/courses/314/edit"
        assert_response :unauthorized
    end


    # ########################################################################
    # Tests for get /courses/:course_id

    test "admin user get course 314" do
        log_in_user(@user_admin, "passwwd")
        get "/courses/314"
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 314, response["result"]["id"]
    end

    test "standard user get course 314" do
        log_in_user(@user_std, "passwwd")
        get "/courses/314"
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 314, response["result"]["id"]
    end

    test "no user get course 314" do
        get "/courses/314"
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 314, response["result"]["id"]
    end

    test "admin user get course 406" do
        log_in_user(@user_admin, "passwwd")
        get "/courses/406"
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 406, response["result"]["id"]
    end

    test "standard user get course 406" do
        log_in_user(@user_std, "passwwd")
        get "/courses/406"
        assert_response :unauthorized  # Unauthorized
    end

    test "no user get course 406" do
        get "/courses/406"
        assert_response :unauthorized
    end


    # ########################################################################
    # Tests for post /courses

    test "standard user successfully post new" do
        log_in_user(@user_std, "passwwd")
        post "/courses", params: { course: { title: "New Course A", description: "Test Description is New", visibility: 0, tier: 0 } }
        assert_response :ok

        response = JSON.parse(@response.body)
    end

    test "standard user unsuccessfully post new" do
        log_in_user(@user_std, "passwwd")
        post "/courses", params: { course: { title: "New Course B", description: "Test Description is New", visibility: 2, tier: 0 } }
        assert_response :bad_request  # Bad data

        response = JSON.parse(@response.body)
    end

    test "no user unsuccessfully post new" do
        post "/courses", params: { course: { title: "New Course B", description: "Test Description is New", visibility: 2, tier: 0 } }
        assert_response :unauthorized
    end

    test "admin user successfully post new" do
        log_in_user(@user_admin, "passwwd")
        post "/courses", params: { course: { title: "New Course C", description: "Test Description is New", visibility: 2, tier: 0 } }
        assert_response :ok

        response = JSON.parse(@response.body)
    end

    test "admin user unsuccessfully post new" do
        log_in_user(@user_admin, "passwwd")
        post "/courses", params: { course: { title: "New Course D", description: "Test Description is New", visibility: 5, tier: 46 } }
        assert_response :bad_request  # Bad data

        response = JSON.parse(@response.body)
    end


    # ########################################################################
    # Tests for put /courses/:course_id

    test "standard user successfully put updated" do
        log_in_user(@user_std, "passwwd")
        put "/courses/416", params: { course: { title: "Updated Course A", description: "Test Description is Updated", visibility: 0, tier: 0 } }
        assert_response :ok

        response = JSON.parse(@response.body)
    end

    test "standard user unsuccessfully put updated" do
        log_in_user(@user_std, "passwwd")
        put "/courses/416", params: { course: { title: "Updated Course B", description: "Test Description is Updated", visibility: 2, tier: 0 } }
        assert_response :bad_request  # Bad data

        response = JSON.parse(@response.body)
    end

    test "unauthorized standard user unsuccessfully put updated" do
        log_in_user(@user_std, "passwwd")
        put "/courses/314", params: { course: { title: "Updated Course B", description: "Test Description is Updated", visibility: 2, tier: 0 } }
        assert_response :unauthorized  # Unauthorized
    end

    test "no user unsuccessfully put updated" do
        put "/courses/314", params: { course: { title: "Updated Course B", description: "Test Description is Updated", visibility: 2, tier: 0 } }
        assert_response :unauthorized
    end

    test "admin user successfully put updated" do
        log_in_user(@user_admin, "passwwd")
        put "/courses/314", params: { course: { title: "Updated Course C", description: "Test Description is Updated", visibility: 2, tier: 0 } }
        assert_response :ok

        response = JSON.parse(@response.body)
    end

    test "admin user unsuccessfully put updated" do
        log_in_user(@user_admin, "passwwd")
        put "/courses/314", params: { course: { title: "Updated Course D", description: "Test Description is Updated", visibility: 5, tier: 46 } }
        assert_response :bad_request  # Bad data

        response = JSON.parse(@response.body)
    end


    # ########################################################################
    # Tests for delete /courses/:course_id

    test "standard user successfully delete" do
        log_in_user(@user_std, "passwwd")

        post "/courses", params: { course: { title: "Deleteable", description: "Test Description please ignore", visibility: 0, tier: 0 } }
        assert_response :ok
        response = JSON.parse(@response.body)
        cid = response["result"]["id"].to_s

        get "/courses/"+cid
        assert_response :ok

        delete "/courses/"+cid
        assert_response :ok

        get "/courses/"+cid
        assert_response :not_found       
    end

    test "standard user unsuccessfully delete" do
        log_in_user(@user_std, "passwwd")

        delete "/courses/999"
        assert_response :not_found      
    end

    test "unauthorized standard user unsuccessfully delete" do
        log_in_user(@user_std, "passwwd")
        delete "/courses/314"
        assert_response :unauthorized  # Unauthorized
    end

    test "no user unsuccessfully delete" do
        delete "/courses/314"
        assert_response :unauthorized
    end

    test "admin user successfully delete" do
        log_in_user(@user_admin, "passwwd")

        post "/courses", params: { course: { title: "Deleteable", description: "Test Description please ignore", visibility: 2, tier: 0 } }
        assert_response :ok
        response = JSON.parse(@response.body)
        cid = response["result"]["id"].to_s

        get "/courses/"+cid
        assert_response :ok

        delete "/courses/"+cid
        assert_response :ok

        get "/courses/"+cid
        assert_response :not_found  
    end

    test "admin user unsuccessfully delete" do
        log_in_user(@user_admin, "passwwd")

        delete "/courses/999"
        assert_response :not_found      
    end
end
