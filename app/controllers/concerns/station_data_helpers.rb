module StationDataHelpers
  extend ActiveSupport::Concern

  private

  def attach_latest_status(stations)
    return stations if stations.blank?

    identifiers = stations.map { |s| s["ID"].to_s }
    latest = StatusReport.latest_by_identifier(identifiers)
    stations.each do |station|
      report = latest[station["ID"].to_s]
      station["LatestStatus"] = report&.status
    end
    stations
  end

  def attach_rating_counts(stations)
    return stations if stations.blank?

    identifiers = stations.map { |s| s["ID"].to_s }
    counts = StationRating.counts_by_identifier(identifiers)
    stations.each do |station|
      id = station["ID"].to_s
      station["LikeCount"] = counts[[ id, true ]] || 0
      station["DislikeCount"] = counts[[ id, false ]] || 0
    end
    stations
  end
end
