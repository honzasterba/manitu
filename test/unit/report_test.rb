require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < Test::Unit::TestCase
  fixtures :reports, :sites, :users, :accounts, :rights
  
  def setup
    ActionMailer::Base.deliveries = []
  end

  help_testing Report, :site_id => "site", :state => Site::STATE_CHECKING
  
  def test_find_for_user
    user = users(:tester)
    assert_equal 3, Report.find_for_user(user).size
    assert_equal 4, Report.find_for_user(user, false).size
  end
  
  def test_finish
    user = users(:tester)
    site = sites(:jansterba)
    report = Report.now(site)
    assert_saved report
    record = Record.new(:check => site.system_check, :report => report)
    record.ok = false
    record.message = "Chyba 500"
    assert record.save
    assert report.finish!
    assert_equal 1, ActionMailer::Base.deliveries.size
    sleep 3 # sleep a while so there is a difference in times
    #now create an ok report
    site.reload
    assert !site.last_report.ok?
    report = Report.now(site)
    assert_saved report
    record = Record.new(:check => site.system_check, :report => report)
    record.ok = true
    record.message = "OK"
    assert record.save
    assert report.finish!
    assert_equal 2, ActionMailer::Base.deliveries.size
    sleep 3 # sleep a while so there is a difference in times
    #next ok report does not send out anything
    site.reload
    assert site.last_report.ok?
    report = Report.now(site)
    assert_saved report
    record = Record.new(:check => site.system_check, :report => report)
    record.ok = true
    record.message = "OK"
    assert record.save
    assert report.finish!
    assert_equal 2, ActionMailer::Base.deliveries.size
  end
end
