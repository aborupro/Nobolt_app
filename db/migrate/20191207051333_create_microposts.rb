class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps precision: 6
    end
    add_index :microposts, %i[user_id created_at]
  end
end
