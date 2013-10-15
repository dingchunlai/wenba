class CreateAskUserScores < ActiveRecord::Migration
  def self.up
    create_table :ask_user_scores do |t|
      t.column :user_id, :integer, :null => false
      t.column :score, :integer, :null => false, :default => 100
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_user_scores
  end
end
