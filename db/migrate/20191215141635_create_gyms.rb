class CreateGyms < ActiveRecord::Migration[5.2]
  def change
    create_table :gyms do |t|
      t.string :name
      t.string :prefecture
      t.string :picture
      t.string :url
      t.string :business_hours
      t.string :address
      t.text :price

      t.timestamps precision: 6
    end
  end
end
