class FavoritesController < ApplicationController
  def create
    @favorite = current_user.favorites.build(favorite_params)
    if @favorite.save
      redirect_back fallback_location: stations_path
    else
      redirect_back fallback_location: stations_path, alert: @favorite.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.favorites.find(params[:id]).destroy
    redirect_back fallback_location: stations_path
  end

  private

  def favorite_params
    params.require(:favorite).permit(:station_identifier, :station_title, :station_lat, :station_lng)
  end
end
