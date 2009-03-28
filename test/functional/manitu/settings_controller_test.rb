require File.dirname(__FILE__) + '/../../test_helper'
require 'manitu/settings_controller'

# Re-raise errors caught by the controller.
class Manitu::SettingsController; def rescue_action(e) raise e end; end

class Manitu::SettingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Manitu::SettingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @user = users(:tester)
  end
  
  fixtures :users, :accounts, :rights

  def test_index
    get :index, {}, :user => @user.id
    assert_response :success
  end
end
