require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :sites

  help_testing User, :password => "honzik", 
    :password_confirmation => "honzik",
    :email => "honzik@manitu.cz"
    
  def test_nick_from_email
    user = create_user(:email => "nick.name@domail.nekde.com")
    assert_equal "nick.name", user.nick, "Nickname returned unexpected value."
  end
  
  def test_confirm
    user = create_user
    old = User.find(user.id)
    assert user.confirm!
    user.reload
    assert_equal User::CONFIRMED, user.state
    assert_not_equal old.token, user.token
  end
  
  def test_state_set
    user = create_user
    assert_equal User::NEW, user.state
  end
  
  def test_token_assigned
    user = create_user
    assert User.sha1(user.email), user.token
  end
  
  def test_assigned_admin_rights
    user = create_user
    user.reload
    assert_equal 1, user.accounts.size
    assert_equal 1, user.rights.size
    right = user.rights[0]
    assert_equal Right::ADMIN, right.rights
  end
  
  def test_account_named
    user = create_user
    assert_equal user.accounts[0].name, user.email
    assign_some_rights_to_account(user.accounts[0])
    user.destroy
    assert user.frozen?
    3.times do |i|
      user = create_user
      assert_equal user.accounts[0].name, user.email+"_"+(i+1).to_s
      assign_some_rights_to_account(user.accounts[0])
      user.destroy
      assert user.frozen?
    end
  end
  
  private
  
    def assign_some_rights_to_account(acc)
      r = Right.new(:account_id => acc.id, :user_id => 1024)
      r.save
      assert_saved r
    end
    
end
