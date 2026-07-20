import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["brand", "model", "hint", "battery", "power"]

  connect() {
    this.populateModels()
  }

  brandChanged() {
    this.populateModels()
  }

  populateModels() {
    const brand = window.vehicleBrandsData[this.brandTarget.value]
    const models = brand ? brand.modeller : []

    this.modelTarget.innerHTML = models
      .map((model) => `<option value="${model.isim}">${model.isim}</option>`)
      .join("")
    this.modelTarget.disabled = models.length === 0
    this.hintTarget.hidden = models.length > 0

    this.modelChanged()
  }

  modelChanged() {
    const brand = window.vehicleBrandsData[this.brandTarget.value]
    const model = brand?.modeller.find((m) => m.isim === this.modelTarget.value)

    this.batteryTarget.value = model?.batarya_kwh ?? ""
    this.powerTarget.value = model?.sarj_gucu_kw ?? ""
  }
}
