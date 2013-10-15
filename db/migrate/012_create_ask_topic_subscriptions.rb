class CreateAskTopicSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :ask_topic_subscriptions do |t|
      t.column :user_id, :integer, :null => false
      t.column :topic_type_id, :integer, :null => false
      t.column :topic_id, :integer, :null => false
      t.column :guest_email, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_topic_subscriptions
  end
end
