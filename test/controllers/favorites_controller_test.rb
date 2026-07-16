require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @favorite = favorites(:one)
  end

  test "create redirects to login when not signed in" do
    assert_no_difference "Favorite.count" do
      post favorites_path, params: { favorite: { station_identifier: "local-999" } }
    end
    assert_redirected_to new_session_path
  end

  test "create saves a favorite for the current user" do
    sign_in_as(@user)

    assert_difference "@user.favorites.count", 1 do
      post favorites_path, params: { favorite: { station_identifier: "local-999", station_title: "Yeni İstasyon", station_lat: 41.0, station_lng: 29.0 } }
    end

    assert_redirected_to stations_path
    assert_equal @user, Favorite.last.user
  end

  test "create redirects back with an alert when the favorite already exists" do
    sign_in_as(@user)

    assert_no_difference "Favorite.count" do
      post favorites_path, params: { favorite: { station_identifier: @favorite.station_identifier } }
    end

    assert_redirected_to stations_path
    assert_equal "Station identifier has already been taken", flash[:alert]
  end

  test "destroy redirects to login when not signed in" do
    delete favorite_path(@favorite)
    assert_redirected_to new_session_path
  end

  test "destroy is not found for a favorite owned by another user" do
    sign_in_as(users(:two))

    assert_no_difference "Favorite.count" do
      delete favorite_path(@favorite)
    end

    assert_response :not_found
  end

  test "destroy removes the favorite for the owning user" do
    sign_in_as(@user)

    assert_difference "Favorite.count", -1 do
      delete favorite_path(@favorite)
    end

    assert_redirected_to stations_path
  end
end
