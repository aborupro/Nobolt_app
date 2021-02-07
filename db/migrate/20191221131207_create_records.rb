class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.string :grade
      t.string :strong_point
      t.string :problem_id
      t.string :picture
      t.references :user, foreign_key: true
      t.references :gym, foreign_key: true

      t.timestamps precision: 6
    end
    add_index :records, %i[user_id gym_id created_at]
  end
end
