class ApplicationController < ActionController::Base
  before_action :log_request
  before_action :set_service
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  private
  def log_request
    puts "have a request"
  end

  def set_service
    @service = OpenChargeMapsService.new
  end
end
