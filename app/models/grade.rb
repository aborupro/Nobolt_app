class Grade < ApplicationRecord
  has_many :records
  validates :name, presence: true, uniqueness: true
  validates :grade_point, presence: true
end
