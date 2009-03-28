class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.column :adress, :string, :null => false
      t.column :state, :string, :null => false
      t.column :account_id, :integer, :null => false
      t.column :updated_at, :datetime
      t.column :last_checked, :datetime
    end
    
    add_index :sites, :account_id
  end

  def self.down
    drop_table :sites
  end
end
