import { Controller } from "@hotwired/stimulus"

console.log("location_filter_controller.js dosyası yüklendi!")

export default class extends Controller {
  static targets = ["province", "district"]

  connect() {
    console.log("location_filter controller bağlandı!")
  }

  updateDistricts() {
    console.log("updateDistricts çalıştı!")
    const selectedProvince = this.provinceTarget.value
    console.log(this.provinceTarget);
    console.log(this.provinceTarget.value);
    const districts = turkeyDistricts[selectedProvince]

    const optionsHtml = districts.map(ilce => `<option value="${ilce}">${ilce}</option>`).join("")
    this.districtTarget.innerHTML = optionsHtml
  }
}