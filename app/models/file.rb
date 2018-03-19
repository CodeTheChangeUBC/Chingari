class File < ApplicationRecord
  belongs_to :attacheable, polymorphic: true
  belongs_to :user
  alias_attribute :creator, :user
end
