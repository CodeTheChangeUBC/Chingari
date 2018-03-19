class Course < ApplicationRecord
  has_many :attachments, as: :attacheables, dependent: :destroy
  belongs_to :user
  alias_attribute :creator, :user
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  alias_attribute :students, :users
end