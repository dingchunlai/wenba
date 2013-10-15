class CreateAskZhishiTopics < ActiveRecord::Migration
  def self.up
    create_table :ask_zhishi_topics do |t|
      t.column :area_id, :integer, :null => false
      t.column :user_id, :integer
      t.column :guest_email, :string
      t.column :ip, :string
      t.column :tag_id, :integer
      t.column :subject, :string, :null => false
      t.column :method, :integer, :null => false
      t.column :description, :text
      t.column :reference, :string
      t.column :is_delete, :integer, :default => 0, :null => false
      t.column :is_close, :integer, :default => 0, :null => false
      t.column :post_counter, :integer, :default => 1, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :editor_id, :integer
      t.column :is_distribute, :integer, :default => 0
      t.column :source, :string
      t.column :source_id, :integer
      t.column :view_counter, :integer, :default => 1, :null => false
    end
  end

  def self.down
    drop_table :ask_zhishi_topics
  end
end
