import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ilSelect", "ilceSelect", "search", "results"]

  connect() {
    this.stations = window.chargingStations || []
    this.populateIlOptions()
    this.renderResults()

    this.ilSelectTarget.addEventListener("change", () => {
      this.populateIlceOptions()
      this.renderResults()
    })
    this.ilceSelectTarget.addEventListener("change", () => this.renderResults())
    this.searchTarget.addEventListener("input", () => this.renderResults())
  }

  populateIlOptions() {
    const provinces = [...new Set(this.stations.map(s => s.AddressInfo.StateOrProvince))].filter(Boolean).sort()
    this.ilSelectTarget.innerHTML = '<option value="">Tüm İller</option>' +
      provinces.map(p => `<option value="${p}">${p}</option>`).join("")
  }

  populateIlceOptions() {
    const il = this.ilSelectTarget.value
    const pool = il ? this.stations.filter(s => s.AddressInfo.StateOrProvince === il) : this.stations
    const districts = [...new Set(pool.map(s => s.AddressInfo.Town))].filter(Boolean).sort()
    this.ilceSelectTarget.innerHTML = '<option value="">Tüm İlçeler</option>' +
      districts.map(d => `<option value="${d}">${d}</option>`).join("")
  }

  renderResults() {
    const il = this.ilSelectTarget.value
    const ilce = this.ilceSelectTarget.value
    const query = this.searchTarget.value.trim().toLowerCase()

    const filtered = this.stations.filter(s => {
      const info = s.AddressInfo
      const matchesIl = !il || info.StateOrProvince === il
      const matchesIlce = !ilce || info.Town === ilce
      const matchesQuery = !query || info.Title.toLowerCase().includes(query)
      return matchesIl && matchesIlce && matchesQuery
    }).slice(0, 30)

    this.resultsTarget.innerHTML = filtered.map(s =>
      `<li class="list-group-item list-group-item-action" style="cursor:pointer" data-title="${s.AddressInfo.Title}">${s.AddressInfo.Title}</li>`
    ).join("")

    this.resultsTarget.querySelectorAll("li").forEach(li => {
      li.addEventListener("click", () => {
        document.getElementById("charging_session_station_name").value = li.dataset.title
      })
    })
  }
}
