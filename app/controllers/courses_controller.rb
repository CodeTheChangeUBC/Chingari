class CoursesController < ApplicationController

  @@page_size = 100
  @@max_page_number = 10

  # Request: GET /courses
  # Authorization: Only available if the requesting user's @current_user.role is Role.admin or Role.moderator.
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Return a JSON of all courses { result: [ course1, course2, ...] }
  def old_index
    c_user = current_user()
    return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in

    schema = {
      tier: Tier.schema,
      visibility: Visibility.schema
    }       

    # Verify that they can access this API endpoint
    if c_user.role == Role.admin or c_user.role == Role.moderator

      # return the courses as a JSON file for the API
      courses = Course.all.order(updated_at: :desc)
      render status: 200, json: { result: courses, schema: schema }
    else
      render status: 401, json: { result: "Not Authorized" }
    end
  end

  # Request: GET /courses/review
  # Authorization: Only available if the requesting user's @current_user.role is Role.admin or Role.moderator.
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Return a JSON of all courses where course.visibility == Visibility.review in the format { result: [ course1, course2, ...] }
  def review
      c_user = current_user()
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in

      schema = {
          tier: Tier.schema,
          visibility: Visibility.schema
      }

      # Verify that they can access this API endpoint
      if c_user.role == Role.admin or c_user.role == Role.moderator

          # return the review courses as a JSON file for the API
          courses = Course.where(visibility: Visibility.reviewing).order(updated_at: :desc)
          render status: 200, json: { result: courses, schema: schema }
      else
          render status: 401, json: { result: "Not Authorized" }
      end
  end

  # Request: GET /courses/drafts
  # Authorization: Only available to logged in user @current_user.id == course.user_id
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Return a JSON of all courses where course.visibility == Visibility.draft and @current_user.id == course.user_id in the format { result: [ course1, course2, ...] }
  def drafts
      c_user = current_user()
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in

      schema = {
          tier: Tier.schema,
          visibility: Visibility.schema
      }

      # return the draft courses as a JSON file for the API
      courses = Course.where(visibility: Visibility.draft, user_id: c_user.id).order(updated_at: :desc)
      render status: 200, json: { result: courses, schema: schema }
  end

  # Request: GET /courses/published
  # Authorization: Available to public
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Return a JSON of all courses where course.visibility == Visibility.published in the format { result: [ course1, course2, ...] }
  def published

      schema = {
          tier: Tier.schema,
          visibility: Visibility.schema
      }

      # return all the published courses as a JSON file for the API
      courses = Course.where(visibility: Visibility.published).order(updated_at: :desc)
      render status: 200, json: { result: courses, schema: schema }
  end

  # Request: GET /courses/?page=1
  # After some redesign I've decided to respec the index route to list the first 1000 visible records, is 100-record pages
  # Arbitrary filtering and UI-level pagination should be managed by the client
  def index
    query_permission = params[:query_permission] || false
    page = params[:page] || 1
    query = []
    schema = {
      title: :text,
      user_id: :reference,
      updated_at: :datetime,
      tier: Tier.schema,
      visibility: Visibility.schema
    }

    if logged_in? == false 
      query = Course.where(visibility: Visibility.published, tier: Tier.free)
    else
      user = current_user()
      if user.role == Role.deactivated || user.role == Role.user
        if user.tier == Tier.free
          query = Course.where(visibility: Visibility.published, tier: Tier.free).or(Course.where(user_id: user.id))
        elsif user.tier == Tier.premium
          query = Course.where(visibility: Visibility.published).or(Course.where(user_id: user.id))
        end
      elsif user.role == Role.moderator || user.role == Role.admin
          query = Course.all
      end
      query = paginate(query.order(updated_at: :desc), page: 1)
    end
    return render status: 200, json: { result: query, schema: schema }
  end

  # Request: GET /courses/(:course_id)?query_permission=false
  # Authorization:
  # - If course.visibility == Visibilityi.published then visible to public
  # - otherwise only available to admin, moderator, and creator of course
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Return a JSON of the course where course.id == course_id in the format { item: { title: "How to kill a mockingbird", description : "...", ... } }
  def show
      c_user = current_user()
      course = Course.where(id: params[:course_id]).first()

      schema = {
        title: :text,
        user_id: :reference,
        updated_at: :datetime,
        description: :textarea,
        tier: Tier.schema,
        visibility: Visibility.schema
      }

      # Course not found case
      if course.nil?
          return ( render status: 404, json: { result: "Not Found" } )
      end

      # Public case:
      if course.visibility == Visibility.published
          render status: 200, json: { result: course, schema: schema }

      # Authenticated case:
      elsif logged_in?  # Ensure that the user is logged in
          # Checks IF user is privledged or owns the course, ELSE return unauthorized
          if c_user.role == Role.admin or c_user.role == Role.moderator or
                  c_user.id == course.user_id then
              render status: 200, json: { result: course }
          else
              render status: 401, json: { result: "Not Authorized" }
          end

      # Course is not (public) AND (owned by user and editable) AND (user is not privledged)
      else
          render status: 401, json: { result: "Not Authorized" }
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
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in
      course = Course.new(user_id: c_user.id)

      schema = {
          title: :text,
          description: :textarea,
          tier: Tier.schema,
          visibility: Visibility.schema
      }

      unless c_user.role == Role.admin or c_user.role == Role.moderator
          schema[:visibility].delete(:published)
          schema[:visibility].delete(:reviewing)
      end

      render status: 200, json: { result: course, schema: schema }
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
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in
      course = Course.where(id: params[:course_id]).first()

      # Course Not Found case
      if course.nil?
          return ( render status: 404, json: { result: "Not Found" } )
      end

      # Attaches a schema 
      schema = {
          title: :text,
          description: :textarea,
          tier: Tier.schema,
          visibility: Visibility.schema
      }

      unless c_user.role == Role.admin or c_user.role == Role.moderator
          schema[:visibility].delete(:published)
          schema[:visibility].delete(:reviewing)
      end

      # Draft Course case
      if course.visibility == Visibility.draft and course.user_id == c_user.id
          render status: 200, json: { result: course, schema: schema }

      # Privledged User case
      elsif c_user.role == Role.admin or c_user.role == Role.moderator
          render status: 200, json: { result: course, schema: schema }

      # Course is not (owned by user and editable) AND (user is not privledged)
      else
          render status: 401, json: { result: "Not Authorized" }
      end
  end

  # Request: POST /courses
  # Authorization: Only available to logged in users
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Create a new course in database based on the request body content.
  # Return a JSON containing the status result of creation and the latest version of the course
  def create
      c_user = current_user()
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in

      # Privledged user case
      if c_user.role == Role.admin or c_user.role == Role.moderator
          course = Course.new(course_params.merge(user_id: c_user.id))
          status = course.save
          if status
              render status: 200, json: { result: course }
          else
              render status: 400, json: { result: "Bad Request" }
          end

      # Non-priledged user case
      else
          # Ensure the data doesn't change visiblity (Standard user cannot publish)
          if course_params[:visibility].to_i == Visibility.draft
              course = Course.new(course_params.merge(user_id: c_user.id))
              status = course.save
              if status
                  render status: 200, json: { result: course }
              else
                  render status: 400, json: { result: "Bad Request" }
              end

          else   
              render status: 400, json: { result: "Bad Request" }             
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
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in
      course = Course.where(id: params[:course_id]).first()

      # Course Not Found case
      if course.nil?
          return ( render status: 404, json: { result: "Not Found" } )
      end

      # Privledged User case
      if c_user.role == Role.admin or c_user.role == Role.moderator
          status = course.update(course_params)
          if status
              render status: 200, json: { result: course }
          else
              render status: 400, json: { result: "Bad Request" }
          end

      # Draft Course case
      elsif course.visibility == Visibility.draft and course.user_id == c_user.id
          # Ensure the data doesn't change visiblity (Standard user cannot publish)
          if course_params[:visibility].to_i == Visibility.draft
              status = course.update(course_params)
              if status
                  render status: 200, json: { result: course }
              else
                  render status: 400, json: { result: "Bad Request" }
              end

          else
              render status: 400, json: { result: "Bad Request" }
          end

      # Course is not (owned by user and editable) AND (user is not privledged)
      else
          render status: 401, json: { result: "Not Authorized" }
      end
  end

  # Request: DELETE /courses/(:course_id)
  # Authorization:
  # - If the course is still a draft then only available to course creator
  # - If the course is not a draft then only available to moderator and admin
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Remove the corresponding course from the database. Return message upon completion
  def delete
      query_permission = params[:query_permission] || false
      c_user = current_user()
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in
      course = Course.where(id: params[:course_id]).first()

      # Course Not Found case
      if course.nil?
          return ( render status: 404, json: { result: "Not Found" } )
      end

      # Draft Course case
      if course.visibility == Visibility.draft and course.user_id == c_user.id
        if query_permission
          render status: 200, json: { result: "Authorized" }
        else
          if course.delete
              render status: 200, json: { result: "Request Processed" }
          else
              render status: 400, json: { result: "Bad Request" }
          end
        end

      # Privledged User case
      elsif c_user.role == Role.admin or c_user.role == Role.moderator
        if query_permission
          render status: 200, json: { result: "Authorized" }
        else
          if course.delete
              render status: 200, json: { result: "Request Processed" }
          else
              render status: 400, json: { result: "Bad Request" }
          end
        end

      # Course is not (owned by user and editable) AND (user is not privledged)
      else
          render status: 401, json: { result: "Not Authorized" }
      end
  end

  private 
    def course_params
        params.require(:course).permit(:title, :description, :tier, :visibility)
    end

end
