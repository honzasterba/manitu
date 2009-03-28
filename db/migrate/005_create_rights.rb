class CreateRights < ActiveRecord::Migration
  def self.up
    create_table :rights do |t|
      t.column :account_id, :integer
      t.column :user_id, :integer
      t.column :rights, :integer
    end
    
    add_index :rights, [:account_id, :user_id], :unique => true
  end

  def self.down
    drop_table :rights
  end
end
