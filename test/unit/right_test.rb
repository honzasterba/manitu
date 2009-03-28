require File.dirname(__FILE__) + '/../test_helper'

class RightTest < Test::Unit::TestCase
  fixtures :rights, :users, :accounts
  
  help_testing Right, :user_id => 2, :account_id => 1
  
  def test_default_rights
    assert_equal Right::READ, create_right.rights
  end

end
