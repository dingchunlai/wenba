require File.dirname(__FILE__) + '/../test_helper'
require 'fangtai_controller'

# Re-raise errors caught by the controller.
class FangtaiController; def rescue_action(e) raise e end; end

class FangtaiControllerTest < Test::Unit::TestCase
  def setup
    @controller = FangtaiController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
