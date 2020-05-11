class AddGradePointToGrades < ActiveRecord::Migration[5.2]
  def change
    add_column :grades, :grade_point, :integer
  end
end
