class OpenChargeMapsService
  BASE_URL = "https://api.openchargemap.io/v3/poi"

  def initialize
    @api_key = Rails.application.credentials.dig(:open_charge_map, :api_key)
  end

  def station(id)
    response = HTTParty.get(BASE_URL, query: {
      output: "json",
      chargepointid: id,
      key: @api_key
    })
    response
  end

  def stations_nearby(lat, lng)
  response = HTTParty.get(BASE_URL, query: {
    output: "json",
    latitude: lat,
    longitude: lng,
    key: @api_key,
    countrycode: "TR"

  })
  response.parsed_response
  end
end
