require "test_helper"

class StationRatingTest < ActiveSupport::TestCase
  setup do
    @rating = station_ratings(:one)
  end

  test "valid with a station_identifier and a user" do
    assert @rating.valid?
  end

  test "invalid without a station_identifier" do
    @rating.station_identifier = nil
    assert_not @rating.valid?
  end

  test "invalid when the same user rates the same station twice" do
    duplicate = StationRating.new(user: @rating.user, station_identifier: @rating.station_identifier, liked: false)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already been taken"
  end

  test "valid when different users rate the same station" do
    third_user = User.create!(email_address: "rating-third@example.com", password: "password", password_confirmation: "password")
    duplicate = StationRating.new(user: third_user, station_identifier: @rating.station_identifier, liked: true)
    assert duplicate.valid?
  end

  test "counts_by_identifier tallies likes and dislikes per station" do
    StationRating.delete_all
    StationRating.create!(user: users(:one), station_identifier: "local-1", liked: true)
    StationRating.create!(user: users(:two), station_identifier: "local-1", liked: true)
    third_user = User.create!(email_address: "rating-counts@example.com", password: "password", password_confirmation: "password")
    StationRating.create!(user: third_user, station_identifier: "local-1", liked: false)

    counts = StationRating.counts_by_identifier([ "local-1" ])

    assert_equal 2, counts[[ "local-1", true ]]
    assert_equal 1, counts[[ "local-1", false ]]
  end

  test "counts_by_identifier returns an empty hash for a blank list" do
    assert_equal({}, StationRating.counts_by_identifier([]))
  end
end
