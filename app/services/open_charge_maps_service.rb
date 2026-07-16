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

  def stations_nearby(lat, lng, distance = nil)
    query = {
      output: "json",
      latitude: lat,
      longitude: lng,
      key: @api_key,
      countrycode: "TR"
    }
    query[:distance] = distance if distance.present?
    query[:distanceunit] = "KM" if distance.present?

    response = HTTParty.get(BASE_URL, query: query)
    response.parsed_response
  end

  def all_stations
    response = HTTParty.get(BASE_URL, query: {
      output: "json",
      key: @api_key,
      countrycode: "TR",
      maxresults: 500
    })
    response.parsed_response
  end

  def stations_count
    response = HTTParty.get(BASE_URL, query: {
      output: "json",
      key: @api_key,
      countrycode: "TR",
      maxresults: 10000,
      compact: true,
      verbose: false
    })
    response.parsed_response.length
  end
end
