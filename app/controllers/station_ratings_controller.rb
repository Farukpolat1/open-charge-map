class StationRatingsController < ApplicationController
  def create
    @rating = current_user.station_ratings.find_or_initialize_by(station_identifier: rating_params[:station_identifier])
    @rating.liked = rating_params[:liked]

    if @rating.save
      redirect_back fallback_location: stations_path, notice: "Oyunuz kaydedildi."
    else
      redirect_back fallback_location: stations_path, alert: @rating.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.station_ratings.find(params[:id]).destroy
    redirect_back fallback_location: stations_path
  end

  private

  def rating_params
    params.require(:station_rating).permit(:station_identifier, :liked)
  end
end
