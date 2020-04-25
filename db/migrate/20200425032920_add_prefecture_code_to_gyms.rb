class AddPrefectureCodeToGyms < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :prefecture_code, :integer
  end
end
