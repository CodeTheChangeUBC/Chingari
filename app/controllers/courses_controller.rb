class CoursesController < ApplicationController

  @@page_size = 10
  @@max_page_number = 20

  # Request: GET /courses/?page=1
  # After some redesign I've decided to respec the index route to list the first 1000 visible records, is 100-record pages
  # Arbitrary filtering and UI-level pagination should be managed by the client
  def index
    search_query = params[:search]
    page = (params[:page] || 1).to_i
    if page < 1 || page > @@max_page_number
      render status: 400, json: { result: "Invalid Page Number" }
    end
    query = []
    schema = {
      title: :text,
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
      query = paginate(search(query.order(updated_at: :desc), search_query, [:title, :description]), page: page, page_size: @@page_size, page_max: @@max_page_number)
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
        description: :textarea,
        updated_at: :datetime,
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
              render status: 400, json: { result: course.errors }
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
                  render status: 400, json: { result: course.errors }
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
              render status: 400, json: { result: course.errors }
          end

      # Draft Course case
      elsif course.user_id == c_user.id
          # Ensure the data doesn't change visiblity (Standard user cannot publish)
          if course_params[:visibility].to_i != Visibility.published
              status = course.update(course_params)
              if status
                  render status: 200, json: { result: course }
              else
                  render status: 400, json: { result: course.errors }
              end

          else
              render status: 400, json: { result: "Not Authorized" }
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
      query_only = params[:query_only] || false
      c_user = current_user()
      return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in
      course = Course.where(id: params[:course_id]).first()

      # Course Not Found case
      if course.nil?
          return ( render status: 404, json: { result: "Not Found" } )
      end

      # Draft Course case
      if course.visibility == Visibility.draft and course.user_id == c_user.id
        if query_only
          render status: 200, json: { result: "Authorized" }
        else
          if course.delete
              render status: 200, json: { result: "Request Processed" }
          else
              render status: 400, json: { result: course.errors }
          end
        end

      # Privledged User case
      elsif c_user.role == Role.admin or c_user.role == Role.moderator
        if query_only
          render status: 200, json: { result: "Authorized" }
        else
          if course.delete
              render status: 200, json: { result: "Request Processed" }
          else
              render status: 400, json: { result: course.errors }
          end
        end

      # Course is not (owned by user and editable) AND (user is not privledged)
      else
          render status: 401, json: { result: "Not Authorized" }
      end
  end



  ####=====================================================================####
  #### => Attachments Api Calls

  # Request: GET /courses/(:course_id)/attachments
  # Authorization:
  # - If the course is still a draft then only available to course creator
  # - If the course is not a draft then only available to moderator and admin
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Returns a JSON list of the attachments of the course
  def attachment_index
    c_user = current_user()
    course = Course.where(id: params[:course_id]).first()

    schema = {
      id: :text, 
      title: :text, 
      user_id: :text,
    }

    # Course not found case
    if course.nil?
        return ( render status: 404, json: { result: "Not Found" } )
    end

    # Course found case
    a_list = Document.where(attachable_id: course.id)
    a_list += Embed.where(attachable_id: course.id)

    # Public case:
    if course.visibility == Visibility.published  
      render status: 200, json: { result: a_list, schema: schema }

    # Authenticated case:
    elsif logged_in?  # Ensure that the user is logged in
      # Checks IF user is privledged or owns the course, ELSE return unauthorized
      if c_user.role == Role.admin or c_user.role == Role.moderator or
          c_user.id == course.user_id then
        render status: 200, json: { result: a_list, schema: schema }
      else
        render status: 401, json: { result: "Not Authorized" }
      end

    # Course is not (public) AND (owned by user and editable) AND (user is not privledged)
    else
        render status: 401, json: { result: "Not Authorized" }
    end
  end

  # Request: GET /courses/(:course_id)/attachments/documents/(:attach_id)
  # Authorization:
  # - If the course is still a draft then only available to course creator
  # - If the course is not a draft then only available to moderator and admin
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Returns a single attachment based on the id
  def attachment_get
    c_user = current_user()
    course = Course.where(id: params[:course_id]).first()

    schema = {
      id: :text, 
      title: :text, 
      user_id: :text,
    }

    # Course not found case
    if course.nil?
        return ( render status: 404, json: { result: "Course Not Found" } )
    end

    # Course found case
    if params[:type] == "documents"
      attache = Document.where(id: params[:attach_id], attachable_id: course.id).first()
    elsif params[:type] == "embeds"
      attache = Embed.where(id: params[:attach_id], attachable_id: course.id).first()
    end

    # Attachment not found case
    if attache.nil?
        return ( render status: 404, json: { result: "Attachable Not Found" } )
    end

    # Public case:
    if course.visibility == Visibility.published  
      render status: 200, json: { result: attache, schema: schema }

    # Authenticated case:
    elsif logged_in?  # Ensure that the user is logged in
      # Checks IF user is privledged or owns the course, ELSE return unauthorized
      if c_user.role == Role.admin or c_user.role == Role.moderator or
          c_user.id == course.user_id then
        render status: 200, json: { result: attache, schema: schema }
      else
        render status: 401, json: { result: "Not Authorized" }
      end

    # Course is not (public) AND (owned by user and editable) AND (user is not privledged)
    else
        render status: 401, json: { result: "Not Authorized" }
    end
  end

  # Request: POST /courses/(:course_id)/attachments
  # Authorization:
  # - If the course is still a draft then only available to course creator
  # - If the course is not a draft then only available to moderator and admin
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Should create the attachment at the index specified, or appended if not specified
  def attachment_create
    c_user = current_user()
    return ( render status: 401, json: { result: "Not Authorized" } ) unless logged_in?  # Ensure the user is logged in
    course = Course.where(id: params[:course_id]).first()

    schema = {
      id: :text, 
      title: :text, 
      user_id: :text,
    }

    # Course not found case
    if course.nil?
      return ( render status: 404, json: { result: "Not Found" } )
    end

    # Authenticated User case
    if c_user.role == Role.admin or c_user.role == Role.moderator or
        course.user_id == c_user.id

      if attach_type_params[:type] == "Document"
        attache = Document.new(attach_params.merge(user_id: c_user.id, attachable_id: course.id, attachable_type: "Course"))
      elsif attach_type_params[:type] == "Embed"
        attache = Embed.new(attach_params.merge(user_id: c_user.id, attachable_id: course.id, attachable_type: "Course"))
      else
        render status: 400, json: { result: "Invalid Type" }
      end

      status = insert_attachable(attache, course.id)

      if status
        render status: 200, json: { result: attache, schema: schema }
      else
        render status: 400, json: { result: attache.errors }
      end

    # Course is not (owned by user and editable) AND (user is not privledged)
    else
      render status: 401, json: { result: "Not Authorized" }
    end
  end

  # Request: PUT /courses/(:course_id)/attachments/(:attach_id)
  # Authorization:
  # - If the course is still a draft then only available to course creator
  # - If the course is not a draft then only available to moderator and admin
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Should edit the attachment, perhaps moving the index as well
  def attachment_edit
  end

  # Request: DELETE /courses/(:course_id)/attachments/(:attach_id)
  # Authorization:
  # - If the course is still a draft then only available to course creator
  # - If the course is not a draft then only available to moderator and admin
  # Unauthorized access: Should get redirected to root (/)
  # Authorized access: Should delete the attachment specified
  def attachment_delete
  end

  private 
    def course_params
        params.require(:course).permit(:title, :description, :tier, :visibility)
    end

    def attach_params
        params.require(:attachment).permit(:title, :display_index)
    end

    def attach_type_params
      params.require(:attachment).permit(:type)
    end

    # WARNING: This method assumes that the user is already authorized
    def insert_attachable(attache, c_id)
      a_list = Document.where(id: c_id)
      a_list += Embed.where(id: c_id)

      a_list.sort! { |x,y| x.display_index <=> y.display_index }

      a_id = attache.display_index
      if a_id.nil? or a_id > a_list.length
        a_list.push(attache)
      else
        a_list.insert(a_id, attache)
      end

      # Update the indices
      a_list.each_with_index {|attache, index| attache.display_index = index }

      # Split and rewite
      begin
        d_list = a_list.find_all { |x| x.class == Document }
        d_list.each(&:save!)

        e_list = a_list.find_all { |x| x.class == Embed }
        e_list.each(&:save!)
      rescue
        status = false
      else
        status = true
      end

      return status
    end
end
