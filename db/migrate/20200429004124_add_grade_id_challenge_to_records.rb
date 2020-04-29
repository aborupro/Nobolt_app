class AddGradeIdChallengeToRecords < ActiveRecord::Migration[5.2]
  def change
    add_reference :records, :grade, foreign_key: true
    add_column :records, :challenge, :string
  end
end
