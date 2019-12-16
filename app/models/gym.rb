class Gym < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
