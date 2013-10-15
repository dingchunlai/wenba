class CreateAskUserOperations < ActiveRecord::Migration
  def self.up
    create_table :ask_user_operations do |t|
      t.column :user_id, :integer, :null => false
      t.column :operation_id, :integer, :null => false
      t.column :operation_count, :integer, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_user_operations
  end
end
