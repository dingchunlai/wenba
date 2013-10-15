require File.dirname(__FILE__) + '/../test_helper'
require 'mine_controller'

# Re-raise errors caught by the controller.
class MineController; def rescue_action(e) raise e end; end

class MineControllerTest < Test::Unit::TestCase
  def setup
    @controller = MineController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
