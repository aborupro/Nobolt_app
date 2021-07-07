class AddLikesCountToRecords < ActiveRecord::Migration[5.2]
  def self.up
    add_column :records, :likes_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :records, :likes_count
  end
end
