class CreateAskTagLinks < ActiveRecord::Migration
  def self.up
    create_table :ask_tag_links do |t|
      t.column :start_id, :integer, :null => false
      t.column :end_id, :integer, :null => false
      t.column :link_weight, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_tag_links
  end
end