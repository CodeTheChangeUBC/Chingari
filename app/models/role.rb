class Role
  # List of User Roles translated into their database encoding

  def self.schema
    {
      admin: 10,
      moderator: 8,
      user: 0,
      deactivated: -1
    }
  end

  # Description: Cannot make any state changes to database (create, update, delete)
  def self.deactivated
    Role.schema[:deactivated]
  end

  # Responsiblities: Manage roles
  # Policies:
  # Can create, submit, and publish content
  # Can view all self-created content
  # Can view all submitted and published content
  # Can change roles of any user
  def self.admin
    Role.schema[:admin]
  end

  # Responsibilities: Publish Content
  # Policies:
  # Can create, submit, and publish content
  # Can view all self-created content
  # Can view all submitted and published content
  def self.moderator
    Role.schema[:moderator]
  end

  # Responsiblities: Create Content
  # Policies:
  # Can create and submit content
  # Can view all self-created content 
  # Can view all published content of qualified tier
  def self.user
    Role.schema[:user]
  end
end