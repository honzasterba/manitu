require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < Test::Unit::TestCase
  fixtures :sites, :accounts, :checks

  help_testing Site, :account_id => 1, :adress => "http://www.site.com"
  
  def test_find_for_checking
    jansterba = sites(:jansterba)
    assert_not_equal jansterba.state, Site::STATE_NEW
    item = Site.find_for_checking
    assert_not_nil item
    assert_equal jansterba.id, item.id
    assert_equal item.state, Site::STATE_CHECKING
  end
  
  def test_system_check
    site, user = get_site_and_user
    check = site.system_check
    assert_not_nil check
    assert check.system?
  end
  
  def test_user_checks
    site, user = get_site_and_user
    checks = site.user_checks
    assert_not_nil checks
    assert_equal 2, checks.size, "Some checks should be found."
    checks.each do |c|
      assert !c.system?
    end
  end
  
  def test_confirm_uri
    site, user = get_site_and_user
    assert site.confirm_uri
  end
  
  def test_url_complete
    site = create_site( :adress => "http://domain.com" )
    assert_saved site
    assert_equal "/", site.adress[site.adress.length-1, 1]
  end
  
  def test_state_set
    site = create_site( :state => nil )
    assert_saved site
    assert_equal Site::STATE_NEW, site.state, "Site state was not initialized."
  end
  
  def test_created_system_check
    site = create_site
    assert_equal 1, site.checks.size, "New site should have 1 check on it."
    assert site.checks.first.system?
    assert site.checks.first.path = "/"
  end
  
  def get_site_and_user
    site = sites(:jansterba)
    assert_not_nil site
    user = site.account.users.first
    assert_not_nil user
    return site, user
  end
end
