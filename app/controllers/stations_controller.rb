class StationsController < ApplicationController
  include StationDataHelpers

  allow_unauthenticated_access only: %i[index show map search]

  def index
    @stations = @service.all_stations
    @stations += Station.all.map { |s| s.as_ocm_json(current_user: current_user) }
    TurkeyLocationService.normalize_addresses!(@stations)
    attach_latest_status(@stations)
    attach_rating_counts(@stations)
  end

  def new
    @station = current_user.stations.build
  end

  def create
    @station = current_user.stations.build(station_params)
    if @station.save
      redirect_to station_path("local-#{@station.id}")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @station = current_user.stations.find(params[:id])
  end

  def update
    @station = current_user.stations.find(params[:id])
    if @station.update(station_params)
      redirect_to station_path("local-#{@station.id}")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @station = current_user.stations.find(params[:id])
    @station.destroy
    redirect_to stations_path
  end

  def show
    if params[:id].start_with?("local-")
      real_id = params[:id].delete_prefix("local-")
      station = Station.find(real_id)
      @station = station.as_ocm_json(current_user: current_user)
    else
    @station = @service.station(params[:id])[0]
    end
    if @station.present?
      identifier = @station["ID"].to_s
      @favorite = current_user&.favorites&.find_by(station_identifier: identifier)
      @latest_status_report = StatusReport.latest_for(identifier)
      @user_rating = current_user&.station_ratings&.find_by(station_identifier: identifier)
      rating_counts = StationRating.counts_by_identifier([ identifier ])
      @like_count = rating_counts[[ identifier, true ]] || 0
      @dislike_count = rating_counts[[ identifier, false ]] || 0
    end
  end

  def map
  if params[:lat].present? && params[:lng].present?
    @stations = @service.stations_nearby(params[:lat], params[:lng])
    local = Station.all.map { |s| s.as_ocm_json(distance: Station.haversine_km(params[:lat].to_f, params[:lng].to_f, s.latitude, s.longitude), current_user: current_user) }
  else
    @stations = @service.all_stations
    local = Station.all.map { |s| s.as_ocm_json(current_user: current_user) }
  end
  @stations += local
  TurkeyLocationService.normalize_addresses!(@stations)
  attach_latest_status(@stations)
  attach_rating_counts(@stations)
  @provinces = TurkeyLocationService.provinces
  end

  def search
  location = params[:location]
  location = [ params[:ilce], params[:il] ].select(&:present?).join(", ") if params[:il].present?

  @location_filtered = location.present?

  if location.present?
    coordinates = GeocodingService.new.geocode(location)
    if coordinates
      @stations = @service.stations_nearby(coordinates[:latitude], coordinates[:longitude], params[:distance])
      local = Station.all.map { |s| s.as_ocm_json(distance: Station.haversine_km(coordinates[:latitude].to_f, coordinates[:longitude].to_f, s.latitude, s.longitude), current_user: current_user) }
      @stations += local
    else
      @stations = []
    end
  else
    @stations = @service.all_stations
    @stations += Station.all.map { |s| s.as_ocm_json(current_user: current_user) }
  end
  TurkeyLocationService.normalize_addresses!(@stations)
  attach_latest_status(@stations)
  attach_rating_counts(@stations)
  @provinces = TurkeyLocationService.provinces

  if params[:view] == "map"
    render "stations/map"
  else
    render "pages/home"
  end
  end

  private
  def station_params
    params.require(:station).permit(:title, :address_line, :town, :province,
     :district, :latitude, :longitude, :connector_type, :level, :quantity, :description)
  end
end
