class CoursesController < ApplicationController

    # Request: GET /courses
    # Authorization: Only available if the requesting user's @current_user.role is Role.admin or Role.moderator.
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Return a JSON of all courses { items: [ course1, course2, ...] }
    def index
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in

        # Verify that they can access this API endpoint
        if c_user.role == Role.admin or c_user.role == Role.moderator

            # return the courses as a JSON file for the API
            courses = Course.all.order(updated_at: :desc)
            render :json => { "items": courses }
        else
            redirect_to :root, :status => 401
        end
    end

    # Request: GET /courses/review
    # Authorization: Only available if the requesting user's @current_user.role is Role.admin or Role.moderator.
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Return a JSON of all courses where course.visibility == Visibility.review in the format { items: [ course1, course2, ...] }
    def review
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in

        # Verify that they can access this API endpoint
        if c_user.role == Role.admin or c_user.role == Role.moderator

            # return the courses as a JSON file for the API
            courses = Course.where(visibility: Visibility.reviewing).order(updated_at: :desc)
            render :json => { "items": courses }
        else
             redirect_to :root, :status => 401
        end
    end

    # Request: GET /courses/drafts
    # Authorization: Only available to logged in user @current_user.id == course.user_id
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Return a JSON of all courses where course.visibility == Visibility.draft and @current_user.id == course.user_id in the format { items: [ course1, course2, ...] }
    def drafts
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in

        courses = Course.where(visibility: Visibility.draft, user_id: c_user.id).order(updated_at: :desc)
        render :json => { "items": courses }
    end

    # Request: GET /courses/published
    # Authorization: Available to public
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Return a JSON of all courses where course.visibility == Visibility.published in the format { items: [ course1, course2, ...] }
    def published        
        courses = Course.where(visibility: Visibility.published).order(updated_at: :desc)
        render :json => { "items": courses }
    end

    # Request: GET /courses/(:course_id)
    # Authorization:
    # - If course.visibility == Visibilityi.publisehd then visible to public
    # - otherwise only available to admin, moderator, and creator of course
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Return a JSON of the course where course.id == course_id in the format { item: { title: "How to kill a mockingbird", description : "...", ... } }
    def getcourse
        c_user = current_user()
        course = Course.where(id: params[:course_id]).first()

        # Course not found case
        if course.nil?
            return ( render :json => {"status": 404},:status => 404 )
        end

        # Public case:
        if course.visibility == Visibility.published
            render :json => course

        # Authenticated case:
        elsif logged_in?  # Ensure that the user is logged in
            if c_user.role == Role.admin or 
                    c_user.role == Role.moderator or
                    c_user.id == course.user_id then
                render :json => course
            else
                redirect_to :root, :status => 401
            end

        # Otherwise If protected course && not logged in:
        else
            redirect_to :login
        end
    end

    # Request: GET /courses/new
    # Authorization: Only available to logged in users
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Create a new course in database based on template.
    # Return a JSON form for editing the new course. Should contain:
    # - A Rails-generated CSRF token for transactions
    # - The template course with all its fields and fill in any fields with the appropriate existing values
    def new
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in
        token = session[:_csrf_token]
        course = Course.new(user_id: c_user.id)

        render :json => { "token": token, "course": course }
    end

    # Request: GET /courses/(:course_id)/edit
    # Authorization:
    # - If the course is still a draft then only available to course creator
    # - If the course is not a draft then only available to moderator and admin
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Create a new course in database based on template.
    # Return a JSON form for editing the existing course. Should contain:
    # - A Rails-generated CSRF token for transactions
    # - The template course with all its fields and fill in any fields with the appropriate existing values
    def edit
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in
        token = session[:_csrf_token]
        course = Course.where(id: params[:course_id]).first()

        # Course not found case
        if course.nil?
            return ( render :json => {"status": 404},:status => 404 )
        end

        # Draft Course case
        if course.visibility == Visibility.draft and course.user_id == c_user.id
            render :json => { "token": token, "course": course }

        # Other Course case
        elsif c_user.role == Role.admin or c_user.role == Role.moderator
            render :json => { "token": token, "course": course }

        # Not draft or authorized
        else
            redirect_to :root, :status => 401
        end
    end

    # Request: POST /courses
    # Authorization: Only available to logged in users
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Create a new course in database based on the request body content.
    # Return a JSON containing the status result of creation and the latest version of the course
    def create
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in

        # Privledged user case
        if c_user.role == Role.admin or c_user.role == Role.moderator
            course = Course.new(course_params.merge(user_id: c_user.id))
            status = course.save
            if status
                render :json => { "status": status, "course": course }
            else
                render :json => { "status": 400 }, :status => 400
            end

        # Non priledged user case
        else 
            if course_params[:visibility].to_i == Visibility.draft
                course = Course.new(course_params.merge(user_id: c_user.id))
                status = course.save
                render :json => { "status": status, "course": course }
            else                
                render :json => { "status": 400 }, :status => 400
            end
        end
    end

    # Request: PUT /courses/(:course_id)
    # Authorization:
    # - If the course is still a draft then only available to course creator
    # - If the course is not a draft then only available to moderator and admin
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Replace the current course with that ID with the one submitted in the form. Return a message upon completion. Special note: only moderators and admins can set visibility to published.
    # Return a JSON containing the status result of creation and the latest version of the course
    def update
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in
        course = Course.where(id: params[:course_id]).first()

        # Course not found case
        if course.nil?
            return ( render :json => {"status": 404},:status => 404 )
        end

        # Other Course case
        if c_user.role == Role.admin or c_user.role == Role.moderator
            status = course.update(course_params)
            if status
                render :json => { "status": status, "course": course }
            else
                render :json => { "status": 400 }, :status => 400
            end

        # Draft Course case
        elsif course.visibility == Visibility.draft and course.user_id == c_user.id
            if course_params[:visibility].to_i == Visibility.draft
                status = course.update(course_params)
                render :json => { "status": status, "course": course }
            else
                render :json => { "status": 400 }, :status => 400
            end

        # Not draft or authorized
        else
            redirect_to :root, :status => 401
        end
    end

    # Request: DELETE /courses/(:course_id)
    # Authorization:
    # - If the course is still a draft then only available to course creator
    # - If the course is not a draft then only available to moderator and admin
    # Unauthorized access: Should get redirected to root (/)
    # Authorized access: Remove the corresponding course from the database. Return message upon completion
    def delete
        c_user = current_user()
        return ( redirect_to :login ) unless logged_in?  # Ensure the user is logged in
        course = Course.where(id: params[:course_id]).first()

        # Course not found case
        if course.nil?
            return ( render :json => {"status": 404},:status => 404 )
        end

        # Draft Course case
        if course.visibility == Visibility.draft and course.user_id == c_user.id
            render :json => { "status": course.delete }
        # Other Course case
        elsif c_user.role == Role.admin or c_user.role == Role.moderator
            render :json => { "status": course.delete }

        # Not draft or authorized
        else
            redirect_to :root, :status => 401
        end
    end

    private 
        def course_params
            params.require(:course).permit(:title, :description, :tier, :visibility)
        end
end
