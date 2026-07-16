require "test_helper"

class StatusReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "create redirects to login when not signed in" do
    assert_no_difference "StatusReport.count" do
      post status_reports_path, params: { status_report: { station_identifier: "local-1", status: "working" } }
    end
    assert_redirected_to new_session_path
  end

  test "create saves a status report for the current user" do
    sign_in_as(@user)

    assert_difference "StatusReport.count", 1 do
      post status_reports_path, params: { status_report: { station_identifier: "local-1", status: "broken" } }
    end

    assert_redirected_to stations_path
    assert_equal @user, StatusReport.last.user
    assert_equal "broken", StatusReport.last.status
  end

  test "create redirects back with an alert for an unknown status" do
    sign_in_as(@user)

    assert_no_difference "StatusReport.count" do
      post status_reports_path, params: { status_report: { station_identifier: "local-1", status: "on_fire" } }
    end

    assert_redirected_to stations_path
    assert_match "Status is not included in the list", flash[:alert]
  end
end
