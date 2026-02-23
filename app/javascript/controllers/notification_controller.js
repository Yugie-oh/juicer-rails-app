import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  static values = { autoDismiss: { type: Number, default: 0 } }

  connect() {
    if (this.autoDismissValue > 0) {
      this.dismissTimeout = setTimeout(() => this.dismiss(), this.autoDismissValue)
    }
  }

  disconnect() {
    if (this.dismissTimeout) clearTimeout(this.dismissTimeout)
  }

  dismiss() {
    if (this.dismissTimeout) {
      clearTimeout(this.dismissTimeout)
      this.dismissTimeout = null
    }
    const el = this.hasToastTarget ? this.toastTarget : this.element
    el.style.transition = "opacity 0.2s ease, transform 0.2s ease"
    el.style.opacity = "0"
    el.style.transform = "translateX(100%)"
    setTimeout(() => this.element.remove(), 200)
  }
}
