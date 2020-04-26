class Record < ApplicationRecord
  belongs_to :user
  belongs_to :gym
  default_scope -> { order(created_at: :desc) }
  validates :grade, presence: true
  validates :strong_point, presence: true
  validates :problem_id, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :gym_id, presence: true
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  private
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "画像は5MBが上限です")
      end
    end
end
