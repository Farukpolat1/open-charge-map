class PagesController < ApplicationController
  include StationDataHelpers

  allow_unauthenticated_access only: [ :home, :about, :contact ]

  def home
    @stations_count = OcmStation.count + Station.count
    @provinces = TurkeyLocationService.provinces

    # Herhangi bir filtre uygulanmamışken harita boş görünmesin diye tüm istasyonları göster.
    # OcmStation.all_as_json artık OCM'e her seferinde gitmiyor, kendi veritabanımızdan
    # okuyor (tazeleme SyncOcmStationsJob ile arka planda, bkz. config/recurring.yml).
    @stations = OcmStation.all_as_json + Station.all.map { |s| s.as_ocm_json(current_user: current_user) }
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
