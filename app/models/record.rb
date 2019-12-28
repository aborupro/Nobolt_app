class Record < ApplicationRecord
  belongs_to :user
  belongs_to :gym
  default_scope -> { order(created_at: :desc) }
  validates :grade, presence: true
  validates :problem_id, presence: true
  validates :user_id, presence: true
  validates :gym_id, presence: true
  mount_uploader :picture, PictureUploader
end
