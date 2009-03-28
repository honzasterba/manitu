class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.column :site_id, :integer, :null => false
      t.column :state, :string, :null => false
      t.column :mailed, :boolean
      t.column :created_at, :datetime, :null => false
    end
    
    add_index :reports, :site_id
    add_index :reports, :state
    add_index :reports, :created_at
  end

  def self.down
    drop_table :reports
  end
end
