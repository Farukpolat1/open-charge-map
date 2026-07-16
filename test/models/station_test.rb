require "test_helper"

class StationTest < ActiveSupport::TestCase
  setup do
    @station = stations(:one)
  end

  test "valid with title, latitude and longitude" do
    assert @station.valid?
  end

  test "invalid without a title" do
    @station.title = nil
    assert_not @station.valid?
    assert_includes @station.errors[:title], "can't be blank"
  end

  test "invalid without a latitude" do
    @station.latitude = nil
    assert_not @station.valid?
  end

  test "invalid with a latitude out of range" do
    @station.latitude = 91
    assert_not @station.valid?

    @station.latitude = -91
    assert_not @station.valid?
  end

  test "invalid without a longitude" do
    @station.longitude = nil
    assert_not @station.valid?
  end

  test "invalid with a longitude out of range" do
    @station.longitude = 181
    assert_not @station.valid?

    @station.longitude = -181
    assert_not @station.valid?
  end

  test "belongs to a user" do
    assert_equal users(:one), @station.user
  end

  test "as_ocm_json prefixes the ID with local- and maps address/connection fields" do
    json = @station.as_ocm_json

    assert_equal "local-#{@station.id}", json["ID"]
    assert_equal @station.title, json["AddressInfo"]["Title"]
    assert_equal @station.address_line, json["AddressInfo"]["AddressLine1"]
    assert_equal @station.province, json["AddressInfo"]["StateOrProvince"]
    assert_equal @station.connector_type, json["Connections"].first["ConnectionType"]["Title"]
    assert_equal @station.quantity, json["Connections"].first["Quantity"]
  end

  test "as_ocm_json includes the given distance" do
    json = @station.as_ocm_json(distance: 4.2)
    assert_equal 4.2, json["AddressInfo"]["Distance"]
  end

  test "as_ocm_json marks IsOwner true only for the owning user" do
    owner_json = @station.as_ocm_json(current_user: @station.user)
    assert_equal true, owner_json["IsOwner"]

    other_json = @station.as_ocm_json(current_user: users(:two))
    assert_equal false, other_json["IsOwner"]
  end

  test "as_ocm_json marks IsOwner false when no current_user is given" do
    json = @station.as_ocm_json
    assert_equal false, json["IsOwner"]
  end

  test "haversine_km returns zero for the same point" do
    assert_in_delta 0, Station.haversine_km(41.0, 29.0, 41.0, 29.0), 0.0001
  end

  test "haversine_km returns the approximate distance between Istanbul and Ankara" do
    istanbul = [ 41.0082, 28.9784 ]
    ankara = [ 39.9334, 32.8597 ]

    distance = Station.haversine_km(*istanbul, *ankara)

    assert_in_delta 350, distance, 15
  end
end
