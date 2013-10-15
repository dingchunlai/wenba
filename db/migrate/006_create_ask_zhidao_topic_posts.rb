class CreateAskZhidaoTopicPosts < ActiveRecord::Migration
  def self.up
    create_table :ask_zhidao_topic_posts do |t|
      t.column :zhidao_topic_id, :integer, :null => false
      t.column :user_id, :integer
      t.column :content, :text
      t.column :vote_counter, :integer, :null => false, :default => 1
      t.column :is_delete, :integer, :null => false, :default => 0
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :method, :integer, :null => false
      t.column :editor_id, :integer
    end
  end

  def self.down
    drop_table :ask_zhidao_topic_posts
  end
end
