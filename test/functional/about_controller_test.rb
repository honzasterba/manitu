require File.dirname(__FILE__) + '/../test_helper'
require 'about_controller'

# Re-raise errors caught by the controller.
class AboutController; def rescue_action(e) raise e end; end

class AboutControllerTest < Test::Unit::TestCase
  def setup
    @controller = AboutController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  fixtures :users, :reports, :sites, :checks, :records
  
  help_testing User, :password => "honzik", 
    :password_confirmation => "honzik",
    :email => "honzik@manitu.cz"
   

  def test_index
    get :index
    assert_response :success
  end
  
  def test_not_found
    get :not_found
    assert_response :missing
  end
  
  def test_login_get
    get :login
    assert_response :success
  end
  
  def test_login_wrong_data
    post :login, :email => "non_existent@manitu.com", :password => "nereknu"
    assert_redirected_to :action => "login"
  end
  
  def test_login_already_logged
    user = create_user
    get :login, {}, :user => user.id
    assert_redirected_to :controller => "manitu/monitoring"
  end
  
  def test_login_correct_data
    pass = "ABCDEFG"
    user = create_user(:password => pass, :password_confirmation => pass)
    user.state = User::CONFIRMED
    assert user.save
    post :login, :email => user.email, :password => pass
    assert_redirected_to :controller => "manitu/monitoring"
    assert_equal user.id, session[:user]
  end
  
  def test_login_wrong_state
    pass = "ABCDEFG"
    user = create_user(:password => pass, :password_confirmation => pass)
    post :login, :email => user.email, :password => pass
    assert_redirected_to :action => "login"
    user.state = User::BLOCKED
    assert user.save
    post :login, :email => user.email, :password => pass
    assert_redirected_to :action => "login"        
  end
  
  def test_register
    get :register
    assert_response :success
  end
  
  def test_register_wrong_data
    post :register, :user => {:email => "neznamy@email_bez_domeny", :password => "short"}
    assert_response :success
  end
  
  def test_confirm
    get :confirm
    assert_response :missing
  end
  
  def test_confirmed_user
    user = create_user
    get :confirm, :id => user.token
    assert_redirected_to :action => "login"
    assert flash[:notice]
    user.reload
    assert User::CONFIRMED, user.state
  end
  
  def test_rss
    get :rss
    assert_response :missing
  end
  
  def test_rss_with_token
    user = users(:tester)
    get :rss, :id => user.token
    assert_response :success
    assert assigns["user"]
    assert assigns["reports"]
    assert 3, assigns["reports"].size
  end
  
  def test_fogot_password
    get :forgot_password, :email => "tester@manitu.cz"
    assert_redirected_to :action => "login"
    assert flash[:notice], "Flash with success message set"
  end
  
end
