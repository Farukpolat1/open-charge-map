class StatusReportsController < ApplicationController
  def create
    @status_report = current_user.status_reports.build(status_report_params)

    if @status_report.save
      redirect_back fallback_location: stations_path, notice: "Bildiriminiz için teşekkürler."
    else
      redirect_back fallback_location: stations_path, alert: @status_report.errors.full_messages.to_sentence
    end
  end

  private

  def status_report_params
    params.require(:status_report).permit(:station_identifier, :status, :comment)
  end
end
