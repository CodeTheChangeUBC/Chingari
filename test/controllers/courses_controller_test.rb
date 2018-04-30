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
        get "/courses"
        assert_response :ok
    end

    test "standard user get index" do
        log_in_user(@user_std, "passwwd")
        get "/courses"
        assert_response :ok  # Unauthorized
    end

    test "no user get index" do
        get "/courses"
        assert_response :ok
    end


    # # ########################################################################
    # # Tests for get /courses/review

    # test "admin user get review" do
    #     log_in_user(@user_admin, "passwwd")
    #     get "/courses/review"
    #     assert_response :ok

    #     response = JSON.parse(@response.body)
    #     response["result"].each do |course|
    #         assert_equal Visibility.reviewing, course['visibility'].to_i
    #     end
    # end

    # test "standard user get review" do
    #     log_in_user(@user_std, "passwwd")
    #     get "/courses/review"
    #     assert_response :unauthorized  # Unauthorized
    # end

    # test "no user get review" do
    #     get "/courses/review"
    #     assert_response :unauthorized
    # end


    # # ########################################################################
    # # Tests for get /courses/drafts

    # test "standard user get drafts" do
    #     log_in_user(@user_std, "passwwd")
    #     get "/courses/drafts"
    #     assert_response :ok

    #     response = JSON.parse(@response.body)
    #     response["result"].each do |course|
    #         assert_equal Visibility.draft, course["visibility"].to_i
    #     end
    # end

    # test "no user get drafts" do
    #     get "/courses/drafts"
    #     assert_response :unauthorized
    # end


    # # ########################################################################
    # # Tests for get /courses/published

    # test "standard user get published" do
    #     log_in_user(@user_std, "passwwd")
    #     get "/courses/published"
    #     assert_response :ok

    #     response = JSON.parse(@response.body)
    #     response["result"].each do |course|
    #         assert_equal Visibility.published, course["visibility"].to_i
    #     end
    # end

    # test "no user get published" do
    #     get "/courses/published"
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
        get "/courses/new"
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal @user_admin.id, response["result"]["user_id"].to_i
        assert_not_nil response["schema"]["visibility"]["published"]
        assert_not_nil response["schema"]["visibility"]["reviewing"]
    end

    test "standard user get new" do
        log_in_user(@user_std, "passwwd")
        get "/courses/new"
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal @user_std.id, response["result"]["user_id"].to_i
        assert_nil response["schema"]["visibility"]["published"]
        assert_nil response["schema"]["visibility"]["reviewing"]
    end

    test "no user get new" do
        get "/courses/new"
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


    # ########################################################################
    # Tests for GET /courses/(:course_id)/attachments

    test "admin user get attachments for 314" do
        log_in_user(@user_admin, "passwwd")
        get '/courses/314/attachments'
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]
    end

    test "admin user get attachments for 322" do
        log_in_user(@user_admin, "passwwd")
        get '/courses/322/attachments'
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]
    end

    test "standard user get attachments for 322" do
        log_in_user(@user_std, "passwwd")
        get '/courses/322/attachments'
        assert_response :unauthorized
    end

    test "no user get attachments for 322" do
        get '/courses/322/attachments'
        assert_response :unauthorized
    end

    # ########################################################################
    # Tests for GET /courses/(:course_id)/attachments/documents/(:attach_id)

    test "admin user get document 1 for 314" do
        log_in_user(@user_admin, "passwwd")
        get '/courses/314/attachments/documents/1'
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 314, response["result"]["attachable_id"]
        assert_equal 1, response["result"]["id"]
    end


    # ########################################################################
    # Tests for GET /courses/(:course_id)/attachments/embeds/(:attach_id)

    test "admin user get embed 314 for 314" do
        log_in_user(@user_admin, "passwwd")
        get '/courses/314/attachments/embeds/314'
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 314, response["result"]["attachable_id"]
        assert_equal 314, response["result"]["id"]
    end


    # ########################################################################
    # Tests for POST /courses/(:course_id)/attachments

    test "admin user post document for 410" do
        log_in_user(@user_admin, "passwwd")
        post '/courses/410/attachments', params: { attachment: { title: "test document", display_index: 88, type: "Document"} }
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]

        get '/courses/410/attachments'
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]
        assert_equal "test document", response["result"][1]["title"]
    end

    test "admin user post embed for 410" do
        log_in_user(@user_admin, "passwwd")
        post '/courses/410/attachments', params: { attachment: { content: '<iframe src="test"></iframe>', display_index: 88, type: "Embed"} }
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]

        get '/courses/410/attachments'
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]
        assert_equal "<iframe src=\"test\"></iframe>", response["result"][1]["content"]
    end

    test "standard user post embed for 410" do
        log_in_user(@user_std, "passwwd")

        put '/courses/410/attachments/6', params: { attachment: { display_index: 47, type: "Embed"} }
        assert_response :unauthorized
    end

    # ########################################################################
    # Tests for PUT /courses/(:course_id)/attachments/(:attach_id)

    test "admin user put document for 314" do
        log_in_user(@user_admin, "passwwd")
        post '/courses/410/attachments', params: { attachment: { content: '<iframe src="test"></iframe>', display_index: 88, type: "Embed"} }
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]
        cid = response["result"]["id"].to_s

        get '/courses/410/attachments/embeds/'+cid
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]
        assert_equal 1, response["result"]["display_index"]
    end

    test "admin user put embed for 410" do
        log_in_user(@user_admin, "passwwd")
        put '/courses/410/attachments/6', params: { attachment: { display_index: 47, type: "Embed"} }
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]

        get '/courses/410/attachments/embeds/6'
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_not_nil response["result"]
        assert_equal 0, response["result"]["display_index"]
    end

    test "standard user put embed for 410" do
        log_in_user(@user_std, "passwwd")

        put '/courses/410/attachments/6', params: { attachment: { display_index: 47, type: "Embed"} }
        assert_response :unauthorized
    end


    # ########################################################################
    # Tests for delete /courses/(:course_id)/attachments/(:attach_id)

    test "admin user delete document for 410" do
        log_in_user(@user_admin, "passwwd")

        post '/courses/410/attachments', params: { attachment: { title: "test delete document", display_index: 88, type: "Document"} }
        assert_response :ok
        response = JSON.parse(@response.body)
        cid = response["result"]["id"].to_s

        get "/courses/410/attachments/documents/"+cid
        assert_response :ok

        delete "/courses/410/attachments/documents/"+cid
        assert_response :ok

        get "/courses/410/attachments/documents/"+cid
        assert_response :not_found  
    end

    test "admin user delete embed for 410" do
        log_in_user(@user_admin, "passwwd")

        post '/courses/410/attachments', params: { attachment: { content: "test delete document", display_index: 88, type: "Embed"} }
        assert_response :ok
        response = JSON.parse(@response.body)
        cid = response["result"]["id"].to_s

        get "/courses/410/attachments/embeds/"+cid
        assert_response :ok

        delete "/courses/410/attachments/embeds/"+cid
        assert_response :ok

        get "/courses/410/attachments/embeds/"+cid
        assert_response :not_found  
    end

    test "standard user delete embed for 410" do
        log_in_user(@user_admin, "passwwd")

        post '/courses/410/attachments', params: { attachment: { content: "test delete document", display_index: 88, type: "Embed"} }
        assert_response :ok
        response = JSON.parse(@response.body)
        cid = response["result"]["id"].to_s
        
        get "/courses/410/attachments/embeds/"+cid
        assert_response :ok

        log_out_user()
        log_in_user(@user_std, "passwwd")

        delete "/courses/410/attachments/embeds/"+cid
        assert_response :unauthorized
    end


    # ########################################################################
    # Tests that check the auto adjustment of the display_index for attachments

    test "check that high display_index gets reduced" do
        log_in_user(@user_admin, "passwwd")

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 5, response["result"][0]['display_index']

        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc', display_index: 3, type: "Document"} }
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 1, response["result"]['display_index']

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Embed", response["result"][0]['type']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Document", response["result"][1]['type']
    end

    test "check that low display_index pushes stack" do
        log_in_user(@user_admin, "passwwd")

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 5, response["result"][0]['display_index']

        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc', display_index: 0, type: "Document"} }
        assert_response :ok

        response = JSON.parse(@response.body)
        assert_equal 0, response["result"]['display_index']

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Document", response["result"][0]['type']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Embed", response["result"][1]['type']

    end

    test "check that the stack is pushed correctly" do
        log_in_user(@user_admin, "passwwd")

        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc 0', display_index: 0, type: "Document"} }
        assert_response :ok
        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc 1', display_index: 1, type: "Document"} }
        assert_response :ok
        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc 2', display_index: 2, type: "Document"} }
        assert_response :ok
        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc 3', display_index: 3, type: "Document"} }
        assert_response :ok
        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc 4', display_index: 4, type: "Document"} }
        assert_response :ok

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Test Doc 0", response["result"][0]['title']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Test Doc 1", response["result"][1]['title']
        assert_equal 2, response["result"][2]['display_index']
        assert_equal "Test Doc 2", response["result"][2]['title']
        assert_equal 3, response["result"][3]['display_index']
        assert_equal "Test Doc 3", response["result"][3]['title']
        assert_equal 4, response["result"][4]['display_index']
        assert_equal "Test Doc 4", response["result"][4]['title']
        assert_equal 5, response["result"][5]['display_index']
        assert_equal "Embed", response["result"][5]['type']

        post '/courses/410/attachments', params: { attachment: { title: 'Test Doc X', display_index: 2, type: "Document"} }
        assert_response :ok
        response = JSON.parse(@response.body)
        c_id = response["result"]["id"].to_s

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Test Doc 0", response["result"][0]['title']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Test Doc 1", response["result"][1]['title']
        assert_equal 2, response["result"][2]['display_index']
        assert_equal "Test Doc X", response["result"][2]['title']
        assert_equal 3, response["result"][3]['display_index']
        assert_equal "Test Doc 2", response["result"][3]['title']
        assert_equal 4, response["result"][4]['display_index']
        assert_equal "Test Doc 3", response["result"][4]['title']
        assert_equal 5, response["result"][5]['display_index']
        assert_equal "Test Doc 4", response["result"][5]['title']
        assert_equal 6, response["result"][6]['display_index']
        assert_equal "Embed", response["result"][6]['type']

        put '/courses/410/attachments/'+c_id, params: { attachment: { display_index: 0, type: "Document"} }
        assert_response :ok

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Test Doc X", response["result"][0]['title']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Test Doc 0", response["result"][1]['title']
        assert_equal 2, response["result"][2]['display_index']
        assert_equal "Test Doc 1", response["result"][2]['title']
        assert_equal 3, response["result"][3]['display_index']
        assert_equal "Test Doc 2", response["result"][3]['title']
        assert_equal 4, response["result"][4]['display_index']
        assert_equal "Test Doc 3", response["result"][4]['title']
        assert_equal 5, response["result"][5]['display_index']
        assert_equal "Test Doc 4", response["result"][5]['title']
        assert_equal 6, response["result"][6]['display_index']
        assert_equal "Embed", response["result"][6]['type']

        put '/courses/410/attachments/'+c_id, params: { attachment: { display_index: 3, type: "Document"} }
        assert_response :ok

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Test Doc 0", response["result"][0]['title']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Test Doc 1", response["result"][1]['title']
        assert_equal 2, response["result"][2]['display_index']
        assert_equal "Test Doc 2", response["result"][2]['title']
        assert_equal 3, response["result"][3]['display_index']
        assert_equal "Test Doc X", response["result"][3]['title']
        assert_equal 4, response["result"][4]['display_index']
        assert_equal "Test Doc 3", response["result"][4]['title']
        assert_equal 5, response["result"][5]['display_index']
        assert_equal "Test Doc 4", response["result"][5]['title']
        assert_equal 6, response["result"][6]['display_index']
        assert_equal "Embed", response["result"][6]['type']

        put '/courses/410/attachments/'+c_id, params: { attachment: { display_index: 1, type: "Document"} }
        assert_response :ok

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Test Doc 0", response["result"][0]['title']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Test Doc X", response["result"][1]['title']
        assert_equal 2, response["result"][2]['display_index']
        assert_equal "Test Doc 1", response["result"][2]['title']
        assert_equal 3, response["result"][3]['display_index']
        assert_equal "Test Doc 2", response["result"][3]['title']
        assert_equal 4, response["result"][4]['display_index']
        assert_equal "Test Doc 3", response["result"][4]['title']
        assert_equal 5, response["result"][5]['display_index']
        assert_equal "Test Doc 4", response["result"][5]['title']
        assert_equal 6, response["result"][6]['display_index']
        assert_equal "Embed", response["result"][6]['type']

        put '/courses/410/attachments/'+c_id, params: { attachment: { display_index: 4, type: "Document"} }
        assert_response :ok

        get '/courses/410/attachments'
        assert_response :ok
        response = JSON.parse(@response.body)
        assert_equal 0, response["result"][0]['display_index']
        assert_equal "Test Doc 0", response["result"][0]['title']
        assert_equal 1, response["result"][1]['display_index']
        assert_equal "Test Doc 1", response["result"][1]['title']
        assert_equal 2, response["result"][2]['display_index']
        assert_equal "Test Doc 2", response["result"][2]['title']
        assert_equal 3, response["result"][3]['display_index']
        assert_equal "Test Doc 3", response["result"][3]['title']
        assert_equal 4, response["result"][4]['display_index']
        assert_equal "Test Doc X", response["result"][4]['title']
        assert_equal 5, response["result"][5]['display_index']
        assert_equal "Test Doc 4", response["result"][5]['title']
        assert_equal 6, response["result"][6]['display_index']
        assert_equal "Embed", response["result"][6]['type']
    end
end
