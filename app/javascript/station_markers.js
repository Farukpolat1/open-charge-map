// Haritanın bulunduğu her sayfada (ana sayfa, /map) ortak kullanılan istasyon
// marker mantığı: kullanıcı eklemesi (local) / OCM istasyonlarını renkle ayırt eder,
// kümeleme (clustering) uygular ve görünen istasyon sayısını günceller.
const OCM_ICON = L.divIcon({ className: "station-marker station-marker-ocm", iconSize: [16, 16] });
const LOCAL_ICON = L.divIcon({ className: "station-marker station-marker-local", iconSize: [16, 16] });

function isLocalStation(station) {
  return typeof station.ID === "string" && station.ID.indexOf("local-") === 0;
}

// OCM verisinde bazı istasyonların koordinatı eksik/hatalı olup (0, 0) olarak geliyor
// (Nijerya açıklarındaki "null island"). Böyle kayıtlar haritanın Türkiye dışına
// zum yapmasına sebep oluyor, bu yüzden Türkiye sınırları dışındaki koordinatları eliyoruz.
function hasValidTurkeyCoordinates(station) {
  var lat = station.AddressInfo.Latitude;
  var lng = station.AddressInfo.Longitude;
  return typeof lat === "number" && typeof lng === "number" &&
    lat >= 35 && lat <= 43 && lng >= 25 && lng <= 45.5;
}

export function createStationLayer(map) {
  const clusterGroup = L.markerClusterGroup();
  map.addLayer(clusterGroup);

  return {
    render: function(stations, showStationDetail, countElementId) {
      clusterGroup.clearLayers();

      const validStations = stations.filter(hasValidTurkeyCoordinates);

      const markers = validStations.map(function(station) {
        const marker = L.marker(
          [station.AddressInfo.Latitude, station.AddressInfo.Longitude],
          { icon: isLocalStation(station) ? LOCAL_ICON : OCM_ICON }
        ).bindTooltip(station.AddressInfo.Title);
        marker.on("click", function() { showStationDetail(station); });
        clusterGroup.addLayer(marker);
        return marker;
      });

      if (countElementId) {
        const countEl = document.getElementById(countElementId);
        if (countEl) countEl.textContent = validStations.length;
      }

      if (markers.length > 0) {
        map.fitBounds(clusterGroup.getBounds(), { padding: [30, 30] });
      }

      return markers;
    }
  };
}
