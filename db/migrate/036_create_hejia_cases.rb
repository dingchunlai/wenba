class CreateHejiaCases < ActiveRecord::Migration
  def self.up
    create_table :hejia_cases do |t|
    end
  end

  def self.down
    drop_table :hejia_cases
  end
end
