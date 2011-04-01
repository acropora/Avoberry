require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get inbox" do
    get :inbox
    assert_response :success
  end

  test "should get sent" do
    get :sent
    assert_response :success
  end

end
