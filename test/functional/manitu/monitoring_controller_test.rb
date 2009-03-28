require File.dirname(__FILE__) + '/../../test_helper'
require 'manitu/monitoring_controller'

# Re-raise errors caught by the controller.
class Manitu::MonitoringController; def rescue_action(e) raise e end; end

class Manitu::MonitoringControllerTest < Test::Unit::TestCase
  def setup
    @controller = Manitu::MonitoringController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user = users(:tester)
  end
  
  fixtures :users, :accounts, :rights, :sites, :checks, :reports, :records

  def test_index
    get :index, {}, {:user => @user.id}
    assert_response :success
  end
  
  def test_refresh_dashboard_no_refresh
    date = Time.now
    acc = @user.accounts.first
    get :refresh_dashboard, {:actual => date.to_s}, :user => @user.id
    assert_response :success
    assert !assigns["change"]
  end
  
  def test_refresh_dashboard_will_refresh
    date = 1.hour.ago
    acc = @user.accounts.first
    rep = Report.create(:site => acc.sites.first, :state => "ok")
    assert_saved rep
    assert rep.created_at > date
    get :refresh_dashboard, {:actual => date.to_s}, :user => @user.id
    assert_response :success
    assert assigns["change"]    
  end
end
