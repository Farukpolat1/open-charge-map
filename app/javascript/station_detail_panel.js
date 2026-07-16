// Haritanın bulunduğu her sayfada (ana sayfa, /map, /stations) ortak kullanılan
// istasyon detay paneli (Bootstrap Offcanvas). Marker'a tıklandığında çağrılacak
// bir showStationDetail(station) fonksiyonu döner.
export function initStationDetailPanel() {
  // OpenChargeMap verisi topluluk katkılı olduğu için innerHTML'e basmadan önce kaçış (escape) uyguluyoruz
  function escapeHtml(value) {
    var div = document.createElement("div");
    div.textContent = value == null ? "" : String(value);
    return div.innerHTML;
  }

  var panelEl = document.getElementById("stationDetailPanel");
  var panel = panelEl ? new bootstrap.Offcanvas(panelEl) : null;
  var titleEl = document.getElementById("stationDetailPanelLabel");
  var bodyEl = document.getElementById("stationDetailBody");

  return function showStationDetail(station) {
    if (!bodyEl) return;

    var address = station.AddressInfo || {};
    var connection = (station.Connections && station.Connections[0]) || {};

    var ownerActionsHtml = "";
    if (station.IsOwner) {
      var plainId = String(station.ID).replace(/^local-/, "");
      ownerActionsHtml =
        "<div class=\"d-flex gap-2 mb-3\">" +
          "<a href=\"/stations/" + encodeURIComponent(plainId) + "/edit\" class=\"btn btn-outline-secondary btn-sm flex-fill\">Düzenle</a>" +
          "<a href=\"/stations/" + encodeURIComponent(plainId) + "\" data-turbo-method=\"delete\" data-turbo-confirm=\"Bu istasyonu silmek istediğinize emin misiniz?\" class=\"btn btn-outline-danger btn-sm flex-fill\">Sil</a>" +
        "</div>";
    }

    var statusHtml = "";
    if (station.LatestStatus === "working") {
      statusHtml = "<div class=\"alert alert-success py-2 mb-3\">✅ Çalışıyor olarak bildirildi</div>";
    } else if (station.LatestStatus === "broken") {
      statusHtml = "<div class=\"alert alert-danger py-2 mb-3\">⚠️ Bozuk olarak bildirildi</div>";
    }

    titleEl.textContent = address.Title || "İstasyon Detayı";
    bodyEl.innerHTML =
      ownerActionsHtml +
      statusHtml +
      "<h6 class=\"text-muted text-uppercase small mb-2\">Adres</h6>" +
      "<p class=\"mb-3\">" + escapeHtml([ address.AddressLine1, address.Town, address.StateOrProvince ].filter(Boolean).join(", ")) + "</p>" +
      "<h6 class=\"text-muted text-uppercase small mb-2\">Bağlantı Bilgisi</h6>" +
      "<ul class=\"list-group list-group-flush mb-3\">" +
        "<li class=\"list-group-item d-flex justify-content-between\"><span>Konnektör Tipi</span><span class=\"fw-semibold\">" + escapeHtml((connection.ConnectionType && connection.ConnectionType.Title) || "-") + "</span></li>" +
        "<li class=\"list-group-item d-flex justify-content-between\"><span>Güç</span><span class=\"fw-semibold\">" + escapeHtml(connection.PowerKW ? connection.PowerKW + " kW" : "-") + "</span></li>" +
        "<li class=\"list-group-item d-flex justify-content-between\"><span>Adet</span><span class=\"fw-semibold\">" + escapeHtml(connection.Quantity || "-") + "</span></li>" +
        "<li class=\"list-group-item d-flex justify-content-between\"><span>Mesafe</span><span class=\"fw-semibold\">" + escapeHtml(address.Distance ? address.Distance.toFixed(1) + " km" : "-") + "</span></li>" +
      "</ul>" +
      "<p class=\"text-muted small mb-3\">👍 " + (station.LikeCount || 0) + " · 👎 " + (station.DislikeCount || 0) + "</p>" +
      "<a href=\"/stations/" + encodeURIComponent(station.ID) + "\" class=\"btn btn-primary w-100\">Tüm Detayları Gör</a>";

    if (panel) panel.show();
  };
}
