class CreateAskAuthorizedUsers < ActiveRecord::Migration
  def self.up
    create_table :ask_authorized_users do |t|
      t.column :user_id, :integer
      t.column :authority_type_id, :integer
      t.column :is_valid, :integer, :default => 1, :null => false
      t.column :expired_at, :datetime
      t.column :editor_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_authorized_users
  end
end
