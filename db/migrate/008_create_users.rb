class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string, :null => false
      t.column :password, :string, :null => false
      t.column :token, :string, :null => false
      t.column :state, :integer
    end
    
    add_index :users, :password
    add_index :users, :email, :unique => true

    u = User.new(:email => "tester@manitu.cz", :password => "honzik",
      :password_confirmation => "honzik")
    u.save!
    u.state = User::CONFIRMED
    u.save!
  end

  def self.down
    drop_table :users
  end
end
