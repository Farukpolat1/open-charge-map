require "test_helper"

class StationRatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @rating = station_ratings(:one)
  end

  test "create redirects to login when not signed in" do
    assert_no_difference "StationRating.count" do
      post station_ratings_path, params: { station_rating: { station_identifier: "local-2", liked: true } }
    end
    assert_redirected_to new_session_path
  end

  test "create saves a new rating for the current user" do
    sign_in_as(@user)

    assert_difference "@user.station_ratings.count", 1 do
      post station_ratings_path, params: { station_rating: { station_identifier: "local-2", liked: true } }
    end

    assert_redirected_to stations_path
    assert_equal true, @user.station_ratings.find_by(station_identifier: "local-2").liked
  end

  test "create changes an existing rating instead of duplicating it" do
    sign_in_as(@user)
    assert_equal true, @rating.liked

    assert_no_difference "StationRating.count" do
      post station_ratings_path, params: { station_rating: { station_identifier: @rating.station_identifier, liked: false } }
    end

    assert_equal false, @rating.reload.liked
  end

  test "destroy redirects to login when not signed in" do
    delete station_rating_path(@rating)
    assert_redirected_to new_session_path
  end

  test "destroy is not found for a rating owned by another user" do
    sign_in_as(users(:two))

    assert_no_difference "StationRating.count" do
      delete station_rating_path(@rating)
    end

    assert_response :not_found
  end

  test "destroy removes the rating for the owning user" do
    sign_in_as(@user)

    assert_difference "StationRating.count", -1 do
      delete station_rating_path(@rating)
    end

    assert_redirected_to stations_path
  end
end
