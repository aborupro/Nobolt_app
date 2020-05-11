class Record < ApplicationRecord
  belongs_to :user
  belongs_to :gym
  belongs_to :grade
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  default_scope -> { order(created_at: :desc) }
  validates :grade_id, presence: true
  validates :strong_point, presence: true
  validates :challenge, presence: true, length: { maximum: 50 }
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
