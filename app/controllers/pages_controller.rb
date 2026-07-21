class PagesController < ApplicationController
  include StationDataHelpers

  allow_unauthenticated_access only: [ :home, :about, :contact ]

  def home
    ocm_count = Rails.cache.fetch("ocm_stations_count_tr", expires_in: 6.hours) { @service.stations_count }
    @stations_count = ocm_count + Station.count
    @provinces = TurkeyLocationService.provinces

    # Herhangi bir filtre uygulanmamışken harita boş görünmesin diye tüm istasyonları göster.
    # OCM'den 2000+ istasyon çekmek maliyetli olduğu için her ana sayfa ziyaretinde değil,
    # 6 saatte bir yenilenecek şekilde cache'liyoruz.
    ocm_stations = Rails.cache.fetch("ocm_all_stations_tr", expires_in: 6.hours) do
      stations = @service.all_stations
      TurkeyLocationService.normalize_addresses!(stations)
    end
    @stations = ocm_stations + Station.all.map { |s| s.as_ocm_json(current_user: current_user) }
    attach_latest_status(@stations)
    attach_rating_counts(@stations)
    @location_filtered = false
  end

  def about
  end

  def contact
    if request.post?
      ContactMailer.notify(
        name: params[:name],
        email: params[:email],
        subject: params[:subject],
        message: params[:message]
      ).deliver_later

      redirect_to contact_path, notice: "Mesajınız için teşekkürler, en kısa sürede size dönüş yapacağız."
    end
  end
end
