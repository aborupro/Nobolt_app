class RemovePrefectureFromGym < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :gyms, :prefectures
    remove_reference :gyms, :prefecture, index: true
  end
end
