class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string, :null => false
      t.column :alias_id, :integer
      t.column :parent_id, :integer
      t.column :tag_level, :integer
      t.column :tag_order, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :tags
  end
end
