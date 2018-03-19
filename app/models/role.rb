class Role
  # List of User Roles translated into their database encoding

  # Description: Cannot make any state changes to database (create, update, delete)
  def Role.deactivated
    -1
  end

  # Responsiblities: Manage roles
  # Policies:
  # Can create, submit, and publish content
  # Can view all self-created content
  # Can view all submitted and published content
  # Can change roles of any user
  def Role.admin
    10
  end

  # Responsibilities: Publish Content
  # Policies:
  # Can create, submit, and publish content
  # Can view all self-created content
  # Can view all submitted and published content
  def Role.moderator
    8
  end

  # Responsiblities: Create Content
  # Policies:
  # Can create and submit content
  # Can view all self-created content 
  # Can view all published content of qualified tier
  def Role.user
    0
  end
end