class OcmStation < ApplicationRecord
  # station_markers.js, station_picker_controller.js gibi JS kodları hâlâ OCM'in
  # ham JSON şeklini (AddressInfo/Connections) beklediği için, kendi tablomuzdaki
  # düz kolonlardan aynı şekli yeniden üretiyoruz - JS tarafına hiç dokunmadan.
  def as_ocm_json(distance: nil)
    {
      "ID" => ocm_id,
      "IsOwner" => false,
      "AddressInfo" => {
        "Distance" => distance,
        "Title" => title,
        "AddressLine1" => address_line,
        "Town" => town,
        "StateOrProvince" => province,
        "Latitude" => latitude&.to_f,
        "Longitude" => longitude&.to_f
      },
      "Connections" => [
        {
          "ConnectionType" => { "Title" => connector_type },
          "Level" => { "Title" => level },
          "Quantity" => quantity
        }
      ]
    }
  end

  # Tüm istasyonları OCM'in JSON şeklinde döndürür (eski @service.all_stations'ın yerine).
  def self.all_as_json
    all.map(&:as_ocm_json)
  end

  # Verilen noktaya belirli bir mesafe (km) içindeki istasyonları, mesafeleriyle
  # birlikte döndürür (eski @service.stations_nearby'nin yerine - artık OCM'e
  # gitmiyor, yerel veritabanındaki koordinatlar üzerinden hesaplıyor).
  def self.near(lat, lng, distance_km = nil)
    lat = lat.to_f
    lng = lng.to_f
    max_distance = distance_km.presence&.to_f

    all.filter_map do |station|
      next unless station.latitude && station.longitude

      distance = Station.haversine_km(lat, lng, station.latitude, station.longitude)
      next if max_distance && distance > max_distance

      station.as_ocm_json(distance: distance)
    end
  end

  # OCM API'den tüm istasyonları çekip yerel tabloya toplu şekilde (tek SQL
  # sorgusuyla, upsert_all) yazar. ocm_id zaten varsa günceller, yoksa ekler.
  def self.sync_from_ocm!
    stations = OpenChargeMapsService.new.all_stations
    TurkeyLocationService.normalize_addresses!(stations)

    now = Time.current
    rows = stations.filter_map do |station|
      info = station["AddressInfo"]
      next unless info && station["ID"].present? && info["Latitude"].present? && info["Longitude"].present?

      connection = (station["Connections"] || []).first || {}

      {
        ocm_id: station["ID"].to_i,
        title: info["Title"],
        address_line: info["AddressLine1"],
        town: info["Town"],
        province: info["StateOrProvince"],
        latitude: info["Latitude"],
        longitude: info["Longitude"],
        connector_type: connection.dig("ConnectionType", "Title"),
        level: connection.dig("Level", "Title"),
        quantity: connection["Quantity"],
        synced_at: now
      }
    end

    return if rows.empty?

    upsert_all(
      rows,
      unique_by: :ocm_id,
      update_only: %i[title address_line town province latitude longitude connector_type level quantity synced_at]
    )
  end
end
