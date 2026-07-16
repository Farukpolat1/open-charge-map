// Haritanın bulunduğu her sayfada (ana sayfa, /map) ortak kullanılan istasyon
// marker mantığı: kullanıcı eklemesi (local) / OCM istasyonlarını renkle ayırt eder,
// kümeleme (clustering) uygular ve görünen istasyon sayısını günceller.
const OCM_ICON = L.divIcon({ className: "station-marker station-marker-ocm", iconSize: [16, 16] });
const LOCAL_ICON = L.divIcon({ className: "station-marker station-marker-local", iconSize: [16, 16] });

function isLocalStation(station) {
  return typeof station.ID === "string" && station.ID.indexOf("local-") === 0;
}

export function createStationLayer(map) {
  const clusterGroup = L.markerClusterGroup();
  map.addLayer(clusterGroup);

  return {
    render: function(stations, showStationDetail, countElementId) {
      clusterGroup.clearLayers();

      const markers = stations.map(function(station) {
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
        if (countEl) countEl.textContent = stations.length;
      }

      if (markers.length > 0) {
        map.fitBounds(clusterGroup.getBounds(), { padding: [30, 30] });
      }

      return markers;
    }
  };
}
