class ProfilesController < ApplicationController
  def show
    @stations = current_user.stations.order(created_at: :desc)
    @total_connectors = @stations.sum { |s| s.quantity || 0 }
    @favorites = current_user.favorites.order(created_at: :desc)
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Profiliniz güncellendi."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :email_address)
  end
end
