class AddAskZhidaoTopicPostsGuestEmailAndIp < ActiveRecord::Migration
  def self.up
    add_column :ask_zhidao_topic_posts, :guest_email, :string
    add_column :ask_zhidao_topic_posts, :ip, :string
  end

  def self.down
    remove_column :ask_zhidao_topic_posts, :guest_email
    remove_column :ask_zhidao_topic_posts, :ip
  end
end