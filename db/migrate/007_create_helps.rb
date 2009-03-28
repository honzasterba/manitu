class CreateHelps < ActiveRecord::Migration
  def self.up
    create_table :helps do |t|
      t.column :title, :string
      t.column :position, :integer
      t.column :content, :text
      t.column :slug, :string
      t.column :updated_at, :string
    end
    
    add_index :helps, :slug, :unique => true
  end

  def self.down
    drop_table :helps
  end
end
