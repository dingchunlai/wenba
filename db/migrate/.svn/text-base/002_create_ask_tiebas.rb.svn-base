class CreateAskTiebas < ActiveRecord::Migration
  def self.up
    create_table :ask_tiebas do |t|
      t.column :area_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :company_name, :string, :null => false
      t.column :description, :string
      t.column :sign, :string
      t.column :icon_url, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_tiebas
  end
end
