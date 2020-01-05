class Gym < ApplicationRecord
  has_many :records
  has_many :users, through: :records
  validates :name, presence: true, uniqueness: true
  mount_uploader :picture, PictureUploader
end
