module ApplicationHelper
  def station_status_badge(station)
    case station["LatestStatus"]
    when "working"
      tag.span("● Aktif", class: "badge bg-success-subtle text-success ms-1")
    when "broken"
      tag.span("● Arızalı", class: "badge bg-danger-subtle text-danger ms-1")
    end
  end
end
