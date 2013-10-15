class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.column :area_id, :integer
      t.column :type_id, :integer
      t.column :entity_id, :integer
      t.column :entity_summary, :text
      t.column :user_id, :integer
      t.column :guest_email, :string
      t.column :ip, :string
      t.column :content, :string
      t.column :is_delete, :integer, :default => 0, :null => false
      t.column :editor_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :replies
  end
end
