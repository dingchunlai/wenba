class CreateAskZhidaoEditorTopics < ActiveRecord::Migration
  def self.up
    create_table :ask_zhidao_editor_topics do |t|
      t.column :editor_id, :integer
      t.column :zhidao_topic_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_zhidao_editor_topics
  end
end
