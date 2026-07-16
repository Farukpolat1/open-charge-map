import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "map"]

  showList() {
    this.listTarget.classList.remove("d-none")
    this.mapTarget.classList.add("d-none")
  }

  showMap() {
    this.mapTarget.classList.remove("d-none")
    this.listTarget.classList.add("d-none")
  }
}