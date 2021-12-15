class Work < ApplicationRecord
  belongs_to :user
  default_scope -> { order(day: :asc) }
  validates :user_id, presence: true
end
