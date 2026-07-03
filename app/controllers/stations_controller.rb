class StationsController < ApplicationController
  def index
    @stations = OpenChargeMapsService.new.stations_nearby(params[:lat], params[:lng])
  end
  def show
    @station = OpenChargeMapsService.new.station(params[:id])[0]
  end
  def map
    @stations = OpenChargeMapsService.new.stations_nearby(params[:lat], params[:lng])
  end
  def search
  if params[:location].present?
    coordinates = GeocodingService.new.geocode(params[:location])
    @stations = @service.stations_nearby(coordinates[:latitude], coordinates[:longitude])
  end
  end
end
