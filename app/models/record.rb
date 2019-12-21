class Record < ApplicationRecord
  belongs_to :user
  belongs_to :gym
  validates :grade, presence: true
  validates :problem_id, presence: true
  mount_uploader :picture, PictureUploader
end
