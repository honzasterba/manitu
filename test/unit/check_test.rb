require File.dirname(__FILE__) + '/../test_helper'

class CheckTest < Test::Unit::TestCase
  fixtures :checks, :sites
  
  help_testing Check, :site_id => 1, :path => "test", :system => false, :active => true
  
  def test_create_root
    c = new_check(:path => "/")
    c.save
    assert_not_saved c, :path
  end
  
  def test_uri_regular
    check = create_check
    assert_equal check.site.adress+check.path, check.uri
  end
  
  def test_uri_system
    check = checks(:system)
    assert_equal check.site.adress, check.uri
  end
  
  def test_last_check
    check = create_check
    assert_equal check.last_record, Record.find(:first, :conditions => {:check_id => check.id }, :order => "created_at DESC")
  end
end
