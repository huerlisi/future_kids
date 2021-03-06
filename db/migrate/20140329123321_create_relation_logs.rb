class CreateRelationLogs < ActiveRecord::Migration
  def change
    create_table :relation_logs do |t|
      t.integer :kid_id, :null => false
      t.integer :user_id, :null => false
      t.string :role
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end

    add_index :relation_logs, :kid_id
    add_index :relation_logs, :user_id
  end
end
