class CreateAskZhidaoTopicPostVotes < ActiveRecord::Migration
  def self.up
    create_table :ask_zhidao_topic_post_votes do |t|
      t.column :zhidao_topic_post_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_zhidao_topic_post_votes
  end
end
