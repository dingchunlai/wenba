class CreateAskZhidaoEditorUploads < ActiveRecord::Migration
  def self.up
    create_table :ask_zhidao_editor_uploads do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :flag, :integer, :default => 0
      t.column :editor_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_zhidao_editor_uploads
  end
end
