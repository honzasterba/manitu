require File.dirname(__FILE__) + '/../../test_helper'
require 'manitu/base_controller'

# Re-raise errors caught by the controller.
class Manitu::BaseController; def rescue_action(e) raise e end; end

class Manitu::BaseControllerTest < Test::Unit::TestCase
  def setup
    @controller = Manitu::BaseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_truth
    #no actions to test here
    assert true
  end
end
