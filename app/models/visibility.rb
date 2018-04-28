class Visibility
  # List of visibility levels used on content such as Courses

  def self.schema
    {
      draft: 0,
      reviewing: 1,
      published: 2
    }
  end

  # Policies:
  # Draft content is visible for edit by creator but does not clutter review pipeline
  def self.draft
    Visibility.schema[:draft]
  end

  # Policies:
  # Review content is visible by creator, moderator, and admin
  # Review content is editable by moderator and admin (eg. change, revert to draft, and publish)
  def self.reviewing
    Visibility.schema[:reviewing]
  end

  # Policies:
  # Published content is visible by all qualified users
  # Published content is editable moderator and admin (eg. change, recall)
  def self.published
    Visibility.schema[:published]
  end
end