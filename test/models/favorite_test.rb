require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  setup do
    @favorite = favorites(:one)
  end

  test "valid with a station_identifier" do
    assert @favorite.valid?
  end

  test "invalid without a station_identifier" do
    @favorite.station_identifier = nil
    assert_not @favorite.valid?
    assert_includes @favorite.errors[:station_identifier], "can't be blank"
  end

  test "invalid when the same user favorites the same station twice" do
    duplicate = Favorite.new(user: @favorite.user, station_identifier: @favorite.station_identifier)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:station_identifier], "has already been taken"
  end

  test "valid when different users favorite the same station" do
    third_user = User.create!(email_address: "third@example.com", password: "password", password_confirmation: "password")
    duplicate = Favorite.new(user: third_user, station_identifier: @favorite.station_identifier)
    assert duplicate.valid?
  end

  test "belongs to a user" do
    assert_equal users(:one), @favorite.user
  end
end
