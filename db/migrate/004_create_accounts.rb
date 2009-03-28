class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column :name, :string
      t.column :rights, :integer
    end
  end

  def self.down
    drop_table :accounts
  end
end
