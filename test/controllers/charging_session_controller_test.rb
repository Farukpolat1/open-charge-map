require "test_helper"

class ChargingSessionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get charging_session_index_url
    assert_response :success
  end

  test "should get create" do
    get charging_session_create_url
    assert_response :success
  end

  test "should get destroy" do
    get charging_session_destroy_url
    assert_response :success
  end
end
