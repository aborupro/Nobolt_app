class Gym < ApplicationRecord
  has_many :records, dependent: :destroy
  has_many :users, through: :records
  validates :name, presence: true, uniqueness: true
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  validates :url, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/, allow_blank: true
  validate :business_hours
  validates :address, presence: true
  validate :price
  validates :prefecture_code, presence: true

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    errors.add(:picture, '画像は5MBが上限です') if picture.size > 5.megabytes
  end
end
