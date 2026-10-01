import { Controller } from "@hotwired/stimulus"

// The Clean Blog navbar without Bootstrap's JavaScript:
// - the Menu button opens and closes the collapsed links on small screens;
// - on large screens the bar slides away while scrolling down and returns
//   when scrolling up (the theme's CSS animates .is-fixed / .is-visible,
//   only above its lg breakpoint).
const LG = 992

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
    const open = this.menuTarget.classList.toggle("show")
    this.toggleTarget.setAttribute("aria-expanded", open)
  }

  onScroll() {
    if (window.innerWidth < LG) return

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
