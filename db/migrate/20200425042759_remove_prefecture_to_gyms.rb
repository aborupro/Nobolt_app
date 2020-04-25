class RemovePrefectureToGyms < ActiveRecord::Migration[5.2]
  def change
    remove_column :gyms, :prefecture, :string
  end
end
