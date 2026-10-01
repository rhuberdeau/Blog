import { Controller } from "@hotwired/stimulus"

// Clean Blog's floating form labels: the label shows once the field has a
// value, and is highlighted while the field has focus.
export default class extends Controller {
  connect() {
    this.update()
  }

  update() {
    const field = this.element.querySelector("input, textarea")
    this.element.classList.toggle("floating-label-form-group-with-value", !!field?.value)
  }

  focus() {
    this.element.classList.add("floating-label-form-group-with-focus")
  }

  blur() {
    this.element.classList.remove("floating-label-form-group-with-focus")
  }
}
