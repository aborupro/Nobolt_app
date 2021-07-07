class Like < ApplicationRecord
  belongs_to :record
  belongs_to :user
  validates_uniqueness_of :record_id, scope: :user_id
  counter_culture :record, column_name: 'likes_count'
end
