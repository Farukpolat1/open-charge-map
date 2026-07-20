class VehiclesController < ApplicationController
  def index
    @vehicles = current_user.vehicles
    @vehicle = Vehicle.new
  end

  def new
    @vehicle = current_user.vehicles.build
  end
  def destroy
    @vehicle = current_user.vehicles.find(params[:id])
    @vehicle.destroy
    redirect_to vehicles_path, notice: "Araç silindi"
  end

  def create
    @vehicle = current_user.vehicles.build(vehicle_params)
    if @vehicle.save
      redirect_to vehicles_path, notice: "Araç Oluştur"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def vehicle_params
    params.expect(vehicle: [ :brand, :model, :year, :battery_capacity, :max_charge_power ])
  end
end
