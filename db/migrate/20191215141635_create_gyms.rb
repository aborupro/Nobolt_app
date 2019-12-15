class CreateGyms < ActiveRecord::Migration[5.2]
  def change
    create_table :gyms do |t|
      t.string :name
      t.string :prefecture
      t.string :picture
      t.string :url
      t.string :business_hours
      t.string :address
      t.string :price

      t.timestamps
    end
  end
end
