class CreateAskTopicTagUrls < ActiveRecord::Migration
  def self.up
    create_table :ask_topic_tag_urls do |t|
      t.column :tag_id, :integer, :null => false
      t.column :topic_url, :string
      t.column :topic_url_type, :string
      t.column :topic_id, :integer
      t.column :topic_type_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_topic_tag_urls
  end
end
