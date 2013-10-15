class CreateAskUserTags < ActiveRecord::Migration
  def self.up
      create_table :ask_user_tags do |t|
      t.column :name, :string, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_user_tags
  end
end
