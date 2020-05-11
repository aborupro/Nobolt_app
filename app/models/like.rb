class Like < ApplicationRecord
  belongs_to :record
  belongs_to :user
  validates_uniqueness_of :record_id, scope: :user_id
end
