import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "cookiePreferences"

export default class extends Controller {
  static targets = ["analytics", "marketing"]

  connect() {
    const stored = this.loadPreferences()
    if (stored) {
      this.analyticsTarget.checked = !!stored.analytics
      this.marketingTarget.checked = !!stored.marketing
    }
  }

  save() {
    const preferences = {
      necessary: true,
      analytics: this.analyticsTarget.checked,
      marketing: this.marketingTarget.checked,
      savedAt: new Date().toISOString()
    }
    localStorage.setItem(STORAGE_KEY, JSON.stringify(preferences))

    const modalEl = this.element.closest(".modal")
    const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl)
    modal.hide()
  }

  loadPreferences() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY)
      return raw ? JSON.parse(raw) : null
    } catch (e) {
      return null
    }
  }
}
