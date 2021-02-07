class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    errors.add(:picture, '画像は5MBが上限です') if picture.size > 5.megabytes
  end
end
