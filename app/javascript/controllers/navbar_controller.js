import { Controller } from "@hotwired/stimulus"

// The Clean Blog navbar, without jQuery or Bootstrap's JS:
// - the mobile menu button toggles the collapsed links;
// - on wide screens the bar slides away while scrolling down and returns
//   when scrolling up (the theme's CSS animates .is-fixed / .is-visible).
const WIDE = 1170

export default class extends Controller {
  static targets = ["menu", "toggle"]

  connect() {
    this.previousTop = 0
    this.onScroll = this.onScroll.bind(this)
    window.addEventListener("scroll", this.onScroll, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll)
  }

  toggle() {
    const open = this.menuTarget.classList.toggle("in")
    this.toggleTarget.setAttribute("aria-expanded", open)
  }

  onScroll() {
    if (window.innerWidth <= WIDE) return

    const nav = this.element
    const currentTop = window.scrollY
    if (currentTop < this.previousTop) {
      if (currentTop > 0 && nav.classList.contains("is-fixed")) {
        nav.classList.add("is-visible")
      } else {
        nav.classList.remove("is-visible", "is-fixed")
      }
    } else {
      nav.classList.remove("is-visible")
      if (currentTop > nav.offsetHeight) nav.classList.add("is-fixed")
    }
    this.previousTop = currentTop
  }
}
