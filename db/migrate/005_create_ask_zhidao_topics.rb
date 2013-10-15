class CreateAskZhidaoTopics < ActiveRecord::Migration
  def self.up
    create_table :ask_zhidao_topics do |t|
      t.column :area_id, :integer, :null => false
      t.column :user_id, :integer
      t.column :tag_id, :integer
      t.column :subject, :string, :null => false
      t.column :method, :integer, :null => false
      t.column :description, :text
      t.column :is_delete, :integer, :null => false, :default => 0
      t.column :is_close, :integer, :null => false, :default => 0
      t.column :best_post_id, :integer
      t.column :post_counter, :integer, :null => false, :default => 1
      t.column :is_vote, :integer, :null => false, :default => 0
      t.column :vote_counter, :integer, :null => false, :default => 1
      t.column :score, :integer, :null => false, :default => 0
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :editor_id, :integer
      t.column :is_distribute, :integer, :default => 0
      t.column :source, :string
      t.column :source_id, :integer
      t.column :view_counter, :integer, :null => false, :default => 1
    end
  end

  def self.down
    drop_table :ask_zhidao_topics
  end
end
