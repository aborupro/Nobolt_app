class RemoveGradeProblemIdFromRecord < ActiveRecord::Migration[5.2]
  def change
    remove_column :records, :grade, :string
    remove_column :records, :problem_id, :string
  end
end
