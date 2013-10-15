class CreateAskTiebaTopics < ActiveRecord::Migration
  def self.up
    create_table :ask_tieba_topics do |t|
      t.column :area_id, :integer, :null => false
      t.column :tieba_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :tag_id, :integer, :null => false
      t.column :subject, :string, :null => false
      t.column :method, :integer, :null => false
      t.column :is_delete, :integer, :null => false, :default => 0
      t.column :post_counter, :integer, :null => false, :default => 1
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_tieba_topics
  end
end
