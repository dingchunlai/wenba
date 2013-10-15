class CreateAskBlockedIps < ActiveRecord::Migration
  def self.up
    create_table :ask_blocked_ips do |t|
      t.column :ip, :string, :null => false
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ask_blocked_ips
  end
end
