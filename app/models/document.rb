class Document < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :user
  alias_attribute :creator, :user
  mount_uploader :file, FileUploader
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
end
