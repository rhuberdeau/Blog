import { Controller } from "@hotwired/stimulus"

// An AI request that hasn't finished: poll its panel every couple of seconds
// and swap it in. The finished panel has no controller, so polling stops.
const INTERVAL_MS = 2000

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.timer = setTimeout(() => this.poll(), INTERVAL_MS)
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  async poll() {
    try {
      const response = await fetch(this.urlValue, { headers: { Accept: "text/html" }, credentials: "same-origin" })
      if (response.ok) {
        this.element.outerHTML = await response.text()
        return
      }
    } catch {
      // Network blip: try again on the next tick.
    }
    this.timer = setTimeout(() => this.poll(), INTERVAL_MS * 2)
  }
}
