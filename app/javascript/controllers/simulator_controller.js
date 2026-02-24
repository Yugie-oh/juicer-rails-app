import { Controller } from "@hotwired/stimulus"

const SECONDS_PER_FRUIT_MS = (60 / 22) * 1000 // ~2.73s per fruit, like juicer-demo
const MECHANISM_ANIMATION_MS = 2500 // match playMechanism() setTimeout

export default class extends Controller {
  static targets = [
    "mechanism", "feeder", "juiceFill", "juiceMl", "fruitsJuiced", "peelPct", "loadKg", "status",
    "juiceForm", "juiceCount", "juiceSubmitBtn"
  ]
  static values = {
    playAnimation: { type: Boolean, default: false },
    juiceOneUrl: String,
    simulatorUrl: String
  }

  connect() {
    if (this.playAnimationValue) {
      requestAnimationFrame(() => {
        setTimeout(() => this.playMechanism(), 100)
      })
    }
  }

  runJuiceBatch(event) {
    event.preventDefault()
    if (!this.hasJuiceCountTarget || !this.hasJuiceSubmitBtnTarget) return

    const count = parseInt(this.juiceCountTarget.value, 10) || 10
    const batchSize = Math.max(1, Math.min(66, count))
    this.juiceSubmitBtnTarget.disabled = true

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    let juiced = 0
    let totalMl = 0

    const run = async () => {
      for (let i = 0; i < batchSize; i++) {
        const res = await fetch(this.juiceOneUrlValue, {
          method: "POST",
          headers: {
            "X-CSRF-Token": csrfToken,
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: "{}"
        })
        const data = await res.json()
        if (!data.ok) break

        juiced++
        totalMl = data.juice_collected_ml
        this.updateStatus(`Juicing... ${juiced}/${batchSize} (${totalMl} ml)`)
        this.playMechanism()
        // Update juice bar and stats only when the Cut · Press · Extract animation completes
        await this.sleep(MECHANISM_ANIMATION_MS)
        this.updateDOM(data)
        const remainder = Math.max(0, SECONDS_PER_FRUIT_MS - MECHANISM_ANIMATION_MS)
        await this.sleep(remainder)
        if (data.safety_shutdown || data.juice_full) break
      }

      this.juiceSubmitBtnTarget.disabled = false
      if (juiced > 0) {
        this.updateStatus(`Juiced ${juiced} fruits — +${totalMl} ml total`, "success")
        if (window.Turbo) window.Turbo.visit(this.simulatorUrlValue)
        else window.location.href = this.simulatorUrlValue
      } else {
        this.updateStatus("Could not juice (power off, safety shutdown, feeder empty, or jug full).", "error")
      }
    }
    run()
  }

  updateDOM(data) {
    if (this.hasFeederTarget) {
      const n = Math.min(data.feeder_count, 50)
      this.feederTarget.innerHTML = Array(n).fill('<div class="w-3 h-3 rounded-full bg-zumex-orange shadow-inner"></div>').join("")
    }
    if (this.hasJuiceFillTarget) this.juiceFillTarget.style.width = `${data.juice_pct}%`
    if (this.hasJuiceMlTarget) this.juiceMlTarget.textContent = data.juice_collected_ml
    if (this.hasFruitsJuicedTarget) this.fruitsJuicedTarget.textContent = data.fruits_juiced
    if (this.hasPeelPctTarget) this.peelPctTarget.textContent = data.peel_pct + "%"
    if (this.hasLoadKgTarget) this.loadKgTarget.textContent = data.load_kg.toFixed(2)
  }

  updateStatus(text, type = "") {
    if (!this.hasStatusTarget) return
    this.statusTarget.textContent = text
    this.statusTarget.className = "text-xs text-center mt-3 " + (type === "success" ? "text-emerald-500" : type === "error" ? "text-red-400" : "text-neutral-500")
  }

  playMechanism() {
    if (!this.hasMechanismTarget) return
    const el = this.mechanismTarget
    el.classList.remove("animate-flow")
    void el.offsetHeight
    el.classList.add("animate-flow")
    setTimeout(() => el.classList.remove("animate-flow"), 2500)
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
}
