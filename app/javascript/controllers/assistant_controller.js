import { Controller } from "@hotwired/stimulus"

// The AI assistant in the article editor. Sends the draft as currently typed
// to the server (AiRequestsController#create), which queues the request and
// returns a panel that polls itself until done (ai_request_controller.js).
// Suggestions change the form only when the author clicks Apply or Use, and
// then exactly like typing: the preview refreshes and the form counts as
// unsaved.
export default class extends Controller {
  static targets = ["results"]
  static values = { url: String, articleId: String }

  async request(event) {
    const button = event.currentTarget
    const form = this.element.closest("form")
    const data = new FormData(form)
    // Same as the preview: not the form's PATCH or its per-form CSRF token.
    data.delete("_method")
    data.delete("authenticity_token")
    data.set("kind", button.dataset.kind)
    if (this.articleIdValue) data.set("article_id", this.articleIdValue)

    button.disabled = true
    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        body: data,
        headers: { Accept: "text/html", "X-CSRF-Token": document.querySelector("meta[name=csrf-token]")?.content },
        credentials: "same-origin"
      })
      this.resultsTarget.insertAdjacentHTML("afterbegin", await response.text())
    } catch {
      this.resultsTarget.insertAdjacentHTML("afterbegin", '<p class="ai-error">Couldn’t reach the server.</p>')
    } finally {
      button.disabled = false
    }
  }

  // Replace the quoted text in the body with the suggestion, but only when
  // the quote appears exactly once; otherwise point at it instead.
  apply(event) {
    const button = event.currentTarget
    const { quote, replacement } = button.dataset
    const body = this.body
    const count = body.value.split(quote).length - 1

    if (count === 1) {
      body.value = body.value.replace(quote, () => replacement)
      body.dispatchEvent(new Event("input", { bubbles: true }))
      this.note(button, "Applied.")
      button.closest("li").classList.add("applied")
      button.disabled = true
    } else if (count === 0) {
      this.note(button, "That text isn’t in the body any more.")
    } else {
      this.note(button, `That text appears ${count} times; use Find and edit it by hand.`)
    }
  }

  find(event) {
    const { quote } = event.currentTarget.dataset
    const body = this.body
    const start = body.value.indexOf(quote)
    if (start === -1) return this.note(event.currentTarget, "That text isn’t in the body any more.")

    this.application.getControllerForElementAndIdentifier(this.element, "preview")?.showWrite()
    body.focus()
    body.setSelectionRange(start, start + quote.length)
  }

  dismiss(event) {
    event.currentTarget.closest("li").remove()
  }

  // Fill a field (title, summary, tags) with a suggestion.
  use(event) {
    const { field, value } = event.currentTarget.dataset
    const input = document.getElementById(field)
    input.value = value
    input.dispatchEvent(new Event("input", { bubbles: true }))
    event.currentTarget.textContent = "Used"
  }

  get body() {
    return document.getElementById("article_body")
  }

  note(button, text) {
    const note = button.closest("li")?.querySelector("[data-role=note]")
    if (note) note.textContent = text
  }
}
