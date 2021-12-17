class Work < ApplicationRecord
  belongs_to :user
  default_scope -> { order(day: :asc) }
  validates :user_id, presence: true
  validates :day, presence: true
  validates :start, presence: true
end
