class Gym < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  mount_uploader :picture, PictureUploader
end
