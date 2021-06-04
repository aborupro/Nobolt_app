class DropTableMicroposts < ActiveRecord::Migration[5.2]
  def change
    drop_table :microposts do |t|
      t.text 'content'
      t.bigint 'user_id'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.string 'picture'
      t.index %w[user_id created_at], name: 'index_microposts_on_user_id_and_created_at'
      t.index ['user_id'], name: 'index_microposts_on_user_id'
    end
  end
end
