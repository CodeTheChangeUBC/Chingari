class Text < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  belongs_to :user
  alias_attribute :creator, :user
end
