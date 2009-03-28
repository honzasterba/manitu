class UserAddRememberToken < ActiveRecord::Migration
  def self.up
    add_column :users, :remember, :string
    add_index :users, :remember
  end

  def self.down
    remove_column :user, :rememer, :string
  end
end
