class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :home, :about, :contact ]

  def home
    ocm_count = Rails.cache.fetch("ocm_stations_count_tr", expires_in: 6.hours) { @service.stations_count }
    @stations_count = ocm_count + Station.count
    @provinces = TurkeyLocationService.provinces
  end

  def about
  end

  def contact
  end
end
