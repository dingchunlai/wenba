class CreateAskUserInfos < ActiveRecord::Migration
  def self.up
    create_table :ask_user_infos do |t|
      t.column :user_id, :integer, :null => false
      t.column :nickname, :string
      t.column :sex, :string
      t.column :sign, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_user_infos
  end
end
