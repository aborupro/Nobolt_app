class Gym < ApplicationRecord
  has_many :records
  has_many :users, through: :records
  validates :name, presence: true, uniqueness: true
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
