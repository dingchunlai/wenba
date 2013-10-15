class CreateAskTopicUserTags < ActiveRecord::Migration
  def self.up
    create_table :ask_topic_user_tags do |t|
      t.column :user_tag_id, :integer
      t.column :topic_type_id, :integer
      t.column :topic_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :editor_id, :integer
    end
  end

  def self.down
    drop_table :ask_topic_user_tags
  end
end
