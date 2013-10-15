class AddAskZhidaoTopicsGuestEmail < ActiveRecord::Migration
  def self.up
    add_column :ask_zhidao_topics, :guest_email, :string
  end

  def self.down
    remove_column :ask_zhidao_topics, :guest_email
  end
end