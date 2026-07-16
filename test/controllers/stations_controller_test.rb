require "test_helper"

class StationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @station = stations(:one)
    @owner = users(:one)
    @other_user = users(:two)
  end

  test "new redirects to login when not signed in" do
    get new_station_path
    assert_redirected_to new_session_path
  end

  test "new renders the form when signed in" do
    sign_in_as(@owner)
    get new_station_path
    assert_response :success
  end

  test "create redirects to login when not signed in" do
    assert_no_difference "Station.count" do
      post stations_path, params: { station: valid_station_params }
    end
    assert_redirected_to new_session_path
  end

  test "create saves a station owned by the current user" do
    sign_in_as(@owner)

    assert_difference "Station.count", 1 do
      post stations_path, params: { station: valid_station_params }
    end

    assert_equal @owner, Station.last.user
    assert_redirected_to station_path("local-#{Station.last.id}")
  end

  test "create ignores a submitted user_id and always uses the current user" do
    sign_in_as(@owner)

    post stations_path, params: { station: valid_station_params.merge(user_id: @other_user.id) }

    assert_equal @owner, Station.last.user
  end

  test "create re-renders the form when invalid" do
    sign_in_as(@owner)

    assert_no_difference "Station.count" do
      post stations_path, params: { station: valid_station_params.merge(title: "") }
    end

    assert_response :unprocessable_entity
  end

  test "edit is not found for a station owned by another user" do
    sign_in_as(@other_user)
    get edit_station_path(@station)
    assert_response :not_found
  end

  test "edit succeeds for the owning user" do
    sign_in_as(@owner)
    get edit_station_path(@station)
    assert_response :success
  end

  test "update is not found for a station owned by another user" do
    sign_in_as(@other_user)

    patch station_path(@station), params: { station: { title: "Hacked" } }

    assert_response :not_found
    assert_not_equal "Hacked", @station.reload.title
  end

  test "update succeeds for the owning user" do
    sign_in_as(@owner)

    patch station_path(@station), params: { station: { title: "Yeni Başlık" } }

    assert_redirected_to station_path("local-#{@station.id}")
    assert_equal "Yeni Başlık", @station.reload.title
  end

  test "destroy is not found for a station owned by another user" do
    sign_in_as(@other_user)

    assert_no_difference "Station.count" do
      delete station_path(@station)
    end

    assert_response :not_found
  end

  test "destroy removes the station for the owning user" do
    sign_in_as(@owner)

    assert_difference "Station.count", -1 do
      delete station_path(@station)
    end

    assert_redirected_to stations_path
  end

  test "show renders a local station without hitting the external API" do
    get station_path("local-#{@station.id}")

    assert_response :success
  end

  test "show returns not found for a nonexistent local station" do
    get station_path("local-999999")

    assert_response :not_found
  end

  test "show renders the latest status report for the station" do
    StatusReport.create!(user: @owner, station_identifier: "local-#{@station.id}", status: "broken")

    get station_path("local-#{@station.id}")

    assert_response :success
    assert_select ".alert-danger", /Bozuk/
  end

  test "show renders a neutral message when the station has no status reports" do
    get station_path("local-#{@station.id}")

    assert_response :success
    assert_select ".alert-secondary", /Henüz durum bildirimi yok/
  end

  test "show renders like and dislike counts for the station" do
    identifier = "local-#{@station.id}"
    StationRating.create!(user: @owner, station_identifier: identifier, liked: true)
    StationRating.create!(user: @other_user, station_identifier: identifier, liked: false)
    sign_in_as(@owner)

    get station_path(identifier)

    assert_response :success
    assert_select "button", /Beğendim \(1\)/
    assert_select "button", /Beğenmedim \(1\)/
  end

  test "show renders like and dislike counts for guests without a session" do
    identifier = "local-#{@station.id}"
    StationRating.create!(user: @owner, station_identifier: identifier, liked: true)
    StationRating.create!(user: @other_user, station_identifier: identifier, liked: false)

    get station_path(identifier)

    assert_response :success
    assert_select "span.text-muted", /👍 1 · 👎 1/
  end

  private

  def valid_station_params
    {
      title: "Test İstasyonu",
      address_line: "Test Cad. No:1",
      town: "Kadıköy",
      province: "İstanbul",
      district: "Kadıköy",
      latitude: 40.99,
      longitude: 29.03,
      connector_type: "Type 2",
      level: "Level 2",
      quantity: 2,
      description: "Test açıklaması"
    }
  end
end
