class CreateAskZhishiTopicPosts < ActiveRecord::Migration
  def self.up
    create_table :ask_zhishi_topic_posts do |t|
      t.column :zhishi_topic_id, :integer, :null => false
      t.column :user_id, :integer
      t.column :guest_email, :string
      t.column :ip, :string
      t.column :content, :text
      t.column :is_delete, :integer, :default => 0, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :method, :integer, :null => false
      t.column :editor_id, :integer
    end
  end

  def self.down
    drop_table :ask_zhishi_topic_posts
  end
end
