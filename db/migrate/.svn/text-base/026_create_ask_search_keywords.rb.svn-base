class CreateAskSearchKeywords < ActiveRecord::Migration
  def self.up
    create_table :ask_search_keywords do |t|
      t.column :area_id, :integer, :null => false
      t.column :type_id, :integer, :null => false
      t.column :keyword, :string, :null => false
      t.column :user_id, :integer
      t.column :ip, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_search_keywords
  end
end
