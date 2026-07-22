class Station < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

 def as_ocm_json(distance: nil, current_user: nil)
  {
    "ID" => "local-#{id}",
    "IsOwner" => current_user.present? && current_user.id == user_id,
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
 def self.haversine_km(lat1, lng1, lat2, lng2)
  rad = Math::PI / 180
  dlat = (lat2 - lat1) * rad
  dlng = (lng2 - lng1) * rad
  a = Math.sin(dlat / 2)**2 + Math.cos(lat1 * rad) * Math.cos(lat2 * rad) * Math.sin(dlng / 2)**2
  6371 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
 end
end
