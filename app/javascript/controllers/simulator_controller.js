import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mechanism"]

  playMechanism() {
    if (!this.hasMechanismTarget) return
    this.mechanismTarget.classList.remove("animate-flow")
    void this.mechanismTarget.offsetHeight
    this.mechanismTarget.classList.add("animate-flow")
    setTimeout(() => this.mechanismTarget.classList.remove("animate-flow"), 2500)
  }
}
