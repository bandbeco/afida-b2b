import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-item"

export default class extends Controller {

  static targets = ["quantity"]

  increment(event) {
    event.preventDefault()
    this.quantityTarget.stepUp()
  }

  decrement(event) {
    event.preventDefault()
    this.quantityTarget.stepDown()
  }
}
