class CreateChecks < ActiveRecord::Migration
  def self.up
    create_table :checks do |t|
       t.column :path, :string, :null => false
       t.column :site_id, :integer, :null => false
       t.column :system, :boolean, :null => false, :default => 0
       t.column :active, :boolean, :null => false, :default => 1
     end
     
     add_index :checks, :site_id
  end

  def self.down
    drop_table :checks
  end
end
