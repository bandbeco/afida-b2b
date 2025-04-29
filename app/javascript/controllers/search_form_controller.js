import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  timeout = null
  debounceWait = 100 // milliseconds

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.debounceWait)
  }

  disconnect() {
    // Clear any pending timeout when the controller is disconnected
    clearTimeout(this.timeout)
  }
} 