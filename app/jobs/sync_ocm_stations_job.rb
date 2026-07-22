class SyncOcmStationsJob < ApplicationJob
  queue_as :default

  def perform
    OcmStation.sync_from_ocm!
  end
end
