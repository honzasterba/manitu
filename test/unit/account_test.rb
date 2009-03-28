require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < Test::Unit::TestCase
  fixtures :accounts, :users, :rights, :reports, :sites

  help_testing Account, :name => "testovací účet"
  
  def setup
    @account = accounts(:main)
  end
  
  def test_last_report
    site = @account.sites.first
    assert site
    last_report_first_value = @account.last_report
    assert last_report_first_value
    report = Report.create(:site => site, :state => Site::STATE_OK)
    assert_saved report
    @account.reload
    assert_not_equal last_report_first_value.id, @account.last_report.id
    assert_equal report, @account.last_report
  end
  
end
