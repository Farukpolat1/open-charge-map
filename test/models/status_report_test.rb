require "test_helper"

class StatusReportTest < ActiveSupport::TestCase
  setup do
    @report = status_reports(:one)
  end

  test "valid with a station_identifier and a known status" do
    assert @report.valid?
  end

  test "invalid without a station_identifier" do
    @report.station_identifier = nil
    assert_not @report.valid?
  end

  test "invalid with an unknown status" do
    @report.status = "on_fire"
    assert_not @report.valid?
    assert_includes @report.errors[:status], "is not included in the list"
  end

  test "belongs to a user" do
    assert_equal users(:one), @report.user
  end

  test "latest_for returns the most recently created report for that station" do
    older = StatusReport.create!(user: users(:one), station_identifier: "local-42", status: "working", created_at: 2.days.ago)
    newer = StatusReport.create!(user: users(:two), station_identifier: "local-42", status: "broken", created_at: 1.hour.ago)

    assert_equal newer, StatusReport.latest_for("local-42")
    assert_not_equal older, StatusReport.latest_for("local-42")
  end

  test "latest_for returns nil when there are no reports for that station" do
    assert_nil StatusReport.latest_for("local-does-not-exist")
  end

  test "latest_by_identifier returns the latest report per station identifier" do
    StatusReport.delete_all
    older = StatusReport.create!(user: users(:one), station_identifier: "local-1", status: "working", created_at: 2.days.ago)
    newer = StatusReport.create!(user: users(:two), station_identifier: "local-1", status: "broken", created_at: 1.hour.ago)
    other = StatusReport.create!(user: users(:one), station_identifier: "local-2", status: "working", created_at: 1.hour.ago)

    result = StatusReport.latest_by_identifier([ "local-1", "local-2", "local-3" ])

    assert_equal newer, result["local-1"]
    assert_equal other, result["local-2"]
    assert_nil result["local-3"]
  end

  test "latest_by_identifier returns an empty hash for a blank list" do
    assert_equal({}, StatusReport.latest_by_identifier([]))
  end
end
