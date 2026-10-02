import { Controller } from "@hotwired/stimulus"

// On the article form: warns before leaving with unsaved edits (closing the
// tab, or following a link through Turbo), and saves on Ctrl+S / Cmd+S
// instead of the browser's "Save page" dialog.
export default class extends Controller {
  // True when the page shows a form whose save just failed: its values were
  // never stored, so they count as unsaved from the start.
  static values = { dirty: Boolean }

  connect() {
    this.snapshot = this.dirtyValue ? null : this.serialize()
    this.onBeforeUnload = this.onBeforeUnload.bind(this)
    this.onBeforeVisit = this.onBeforeVisit.bind(this)
    this.onKeydown = this.onKeydown.bind(this)
    window.addEventListener("beforeunload", this.onBeforeUnload)
    document.addEventListener("turbo:before-visit", this.onBeforeVisit)
    window.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    window.removeEventListener("beforeunload", this.onBeforeUnload)
    document.removeEventListener("turbo:before-visit", this.onBeforeVisit)
    window.removeEventListener("keydown", this.onKeydown)
  }

  // The form as it was last saved (or loaded); submitting counts as saving.
  saved() {
    this.snapshot = this.serialize()
  }

  get dirty() {
    return this.snapshot === null || this.serialize() !== this.snapshot
  }

  serialize() {
    const data = new FormData(this.element)
    data.delete("authenticity_token")
    return new URLSearchParams(data).toString()
  }

  onBeforeUnload(event) {
    if (this.dirty) event.preventDefault()
  }

  onBeforeVisit(event) {
    if (this.dirty && !window.confirm("Discard unsaved changes?")) event.preventDefault()
  }

  onKeydown(event) {
    if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "s") {
      event.preventDefault()
      this.element.requestSubmit()
    }
  }
}
