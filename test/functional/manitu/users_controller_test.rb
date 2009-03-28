require File.dirname(__FILE__) + '/../../test_helper'
require 'manitu/users_controller'

# Re-raise errors caught by the controller.
class Manitu::UsersController; def rescue_action(e) raise e end; end

class Manitu::UsersControllerTest < Test::Unit::TestCase
  def setup
    @controller = Manitu::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @user = users(:tester)
  end
  
  fixtures :users, :accounts, :rights

  def test_index
    get :index, {}, :user => @user.id
    assert_response :success
  end
  
  def test_change_pass_ok
    post :set_pass, { :password => "nove_heslo", :password_confirmation => "nove_heslo" },
      :user => @user.id
    assert_redirected_to :action => "index"
    @user.reload
    assert_equal User.sha1("nove_heslo"), @user.password
    assert_not_nil flash[:notice]
    assert_nil flash[:error]
  end
  
  def test_change_pass_fail
    post :set_pass, { :password => "nove_heslo", :password_confirmation => "jine_heslo" },
      :user => @user.id
    assert_redirected_to :action => "index"
    @user.reload
    assert_not_equal User.sha1("nove_heslo"), @user.password    
    assert_nil flash[:notice]
    assert_not_nil flash[:error]
  end
end
