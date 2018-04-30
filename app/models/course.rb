class Course < ApplicationRecord
  has_many :attachments, as: :attachables, dependent: :destroy
  belongs_to :user
  alias_attribute :creator, :user
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  alias_attribute :students, :users

  validates :title, presence: true, length: { minimum: 1 , maximum: 140 } 
  validates :user_id, presence: true 
  validates_associated :user 
  validates :description, presence: true, length: { minimum: 1 , maximum: 10000 } 
  validates :visibility, numericality: true, inclusion: { in: [Visibility.draft, Visibility.reviewing, Visibility.published] } 
  validates :tier, numericality: true, inclusion: { in: [Tier.free, Tier.premium] } 
end