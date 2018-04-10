class Visibility
  # List of visibility levels used on content such as Courses

  # Policies:
  # Draft content is visible for edit by creator but does not clutter review pipeline
  def self.draft
    0
  end

  # Policies:
  # Review content is visible by creator, moderator, and admin
  # Review content is editable by moderator and admin (eg. change, revert to draft, and publish)
  def self.reviewing
    1
  end

  # Policies:
  # Published content is visible by all qualified users
  # Published content is editable moderator and admin (eg. change, recall)
  def self.published
    2
  end
end