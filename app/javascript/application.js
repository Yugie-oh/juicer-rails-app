// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Prevent any scroll when Turbo loads the page (e.g. after power button or other redirects)
function preventScroll() {
  if (document.activeElement && document.activeElement !== document.body) {
    document.activeElement.blur()
  }
  window.scrollTo(0, 0)
  document.documentElement.scrollTop = 0
  document.body.scrollTop = 0
}
document.addEventListener("turbo:load", preventScroll)
document.addEventListener("turbo:render", preventScroll)
