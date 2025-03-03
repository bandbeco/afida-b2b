import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error"]
  static values = {
    endpoint: { type: String, default: "https://api.postcodes.io/postcodes" }
  }

  async validate() {
    const postcode = this.inputTarget.value.trim()
    if (!postcode) return

    try {
      const response = await fetch(`${this.endpointValue}/${encodeURIComponent(postcode)}/validate`)
      const data = await response.json()

      if (data.result) {
        this.inputTarget.classList.remove("border-red-500")
        this.errorTarget.textContent = ""
      } else {
        this.inputTarget.classList.add("border-red-500")
        this.errorTarget.textContent = "Please enter a valid UK postcode"
        this.errorTarget.classList.remove("hidden")
      }
    } catch (error) {
      console.error("Postcode validation error:", error)
    }
  }

  // Debounce the validation to avoid too many API calls
  validateDebounced(event) {
    if (this.timeout) clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.validate(), 500)
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }
} 