import { Controller } from "@hotwired/stimulus"

// Live preview for the article editor. The server renders the form's current
// values with the same partial as the article page (ArticlesController#preview),
// so what you see here is exactly what readers will get. Also keeps the word
// count up to date and switches Write / Preview tabs on narrow screens.
const DELAY_MS = 300
// Same rule and speed as Article#word_count / #reading_minutes.
const WORDS_PER_MINUTE = 230

export default class extends Controller {
  static targets = ["output", "body", "count", "writeTab", "previewTab"]
  static values = { url: String }

  disconnect() {
    clearTimeout(this.timer)
    this.request?.abort()
  }

  refresh() {
    this.updateCount()
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.render(), DELAY_MS)
  }

  async render() {
    this.request?.abort()
    this.request = new AbortController()

    const form = this.element.closest("form")
    const data = new FormData(form)
    // The edit form says PATCH via a hidden _method field; the preview is a POST.
    // Its authenticity_token is a per-form token bound to the form's own URL,
    // so send the page's global token (csrf_meta_tags) in the header instead.
    data.delete("_method")
    data.delete("authenticity_token")
    const token = document.querySelector("meta[name=csrf-token]")?.content

    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        body: data,
        headers: { Accept: "text/html", "X-CSRF-Token": token },
        signal: this.request.signal,
        credentials: "same-origin"
      })
      if (response.ok) {
        this.outputTarget.innerHTML = await response.text()
        this.element.classList.remove("preview-stale")
      } else {
        this.element.classList.add("preview-stale")
      }
    } catch (error) {
      if (error.name !== "AbortError") this.element.classList.add("preview-stale")
    }
  }

  updateCount() {
    const words = (this.bodyTarget.value.match(/\S+/g) || []).length
    const minutes = Math.max(Math.ceil(words / WORDS_PER_MINUTE), 1)
    this.countTarget.textContent = `${words} ${words === 1 ? "word" : "words"} · ${minutes} min read`
  }

  showWrite() {
    this.setMode("write")
  }

  showPreview() {
    this.setMode("preview")
    this.render()
  }

  setMode(mode) {
    this.element.dataset.mode = mode
    this.writeTabTarget.setAttribute("aria-selected", mode === "write")
    this.previewTabTarget.setAttribute("aria-selected", mode === "preview")
  }
}
