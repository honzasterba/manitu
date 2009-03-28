class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.column :check_id, :integer, :null => false
      t.column :report_id, :integer, :null => false
      t.column :message, :string, :null => false
      t.column :status, :integer, :null => false
      t.column :length, :integer, :null => false
      t.column :body, :string
      t.column :ok, :boolean
      t.column :created_at, :datetime
    end
    
    add_index :records, :check_id
    add_index :records, :created_at
  end

  def self.down
    drop_table :records
  end
end
