class CreateAskScoreOrders < ActiveRecord::Migration
  def self.up
    create_table :ask_score_orders do |t|
      t.column :operation_id, :integer, :null => false
      t.column :operation_score, :integer, :null => false
      t.column :version, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_score_orders
  end
end
