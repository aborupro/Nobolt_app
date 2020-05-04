class CreateGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :grades do |t|
      t.string :name

      t.timestamps precision: 6
    end
  end
end
