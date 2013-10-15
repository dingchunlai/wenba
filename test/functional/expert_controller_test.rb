require File.dirname(__FILE__) + '/../test_helper'
require 'expert_controller'

# Re-raise errors caught by the controller.
class ExpertController; def rescue_action(e) raise e end; end

class ExpertControllerTest < Test::Unit::TestCase
  def setup
    @controller = ExpertController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
