class ChargingSessionsController < ApplicationController
  def index
    @vehicle = current_user.vehicles.find(params[:vehicle_id])
    @charging_sessions = @vehicle.charging_sessions.order(started_at: :desc)
    @total_kwh = @charging_sessions.sum(:kwh_used)
    @total_paid = @charging_sessions.sum(:amount_paid)
  end
  def new
    @vehicle = current_user.vehicles.find(params[:vehicle_id])
    @charging_session = @vehicle.charging_sessions.build
    @stations = OcmStation.all_as_json
  end

  def create
        @vehicle = current_user.vehicles.find(params[:vehicle_id])
    @charging_session = @vehicle.charging_sessions.build(
      charging_session_params.merge(status: "active", started_at: Time.current)
    )
    if @charging_session.save
      redirect_to vehicle_charging_sessions_path(@vehicle), notice: "Şarj oturumu başlatıldı"
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    @vehicle = current_user.vehicles.find(params[:vehicle_id])
    @charging_session = @vehicle.charging_sessions.find(params[:id])
  end

  def update
    @vehicle = current_user.vehicles.find(params[:vehicle_id])
    @charging_session = @vehicle.charging_sessions.find(params[:id])
    duration_minutes = ((Time.current - @charging_session.started_at) / 60.0).round
    if @charging_session.update(charging_session_update_params.merge(status: "completed", duration_minutes: duration_minutes))
      redirect_to vehicle_charging_sessions_path(@vehicle), notice: "Şarj tamamlandı"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle = current_user.vehicles.find(params[:vehicle_id])
    @charging_session = @vehicle.charging_sessions.find(params[:id])
    @charging_session.destroy
    redirect_to vehicle_charging_sessions_path(@vehicle), notice: "Şarj kaydı silindi"
  end


  private
  def charging_session_params
    params.expect(charging_session: [ :station_name, :power_kw ])
  end

  def charging_session_update_params
    params.expect(charging_session: [ :amount_paid ])
  end
end
