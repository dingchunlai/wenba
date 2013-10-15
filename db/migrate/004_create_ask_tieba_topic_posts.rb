class CreateAskTiebaTopicPosts < ActiveRecord::Migration
  def self.up
    create_table :ask_tieba_topic_posts do |t|
      t.column :tieba_topic_id, :integer, :null => false
      t.column :user_id, :integer
      t.column :content, :text
      t.column :is_delete, :integer, :null => false, :default => 0
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_tieba_topic_posts
  end
end
