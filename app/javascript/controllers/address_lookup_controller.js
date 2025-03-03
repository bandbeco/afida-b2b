import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["postcode", "result", "error", "submit", "cityField", "postcodeField"]

  static values = {
    loading: Boolean,
    addressType: String
  }

  connect() {
    this.loadingValue = false
  }

  async search(event) {
    event.preventDefault()
    const postcode = this.postcodeTarget.value.trim()

    if (!postcode) return

    this.loadingValue = true
    this.errorTarget.textContent = ""
    this.submitTarget.disabled = true

    try {
      const response = await fetch(`/postcode_lookup?postcode=${encodeURIComponent(postcode)}`, {
        headers: {
          "Accept": "application/json",
          "X-Requested-With": "XMLHttpRequest"
        }
      })

      const data = await response.json()

      if (data.status === 200) {
        this.autocomplete(data.result)
      } else {
        this.errorTarget.textContent = data.error || "Unable to find postcode"
      }
    } catch (error) {
      console.log(error)
      this.errorTarget.textContent = "An error occurred while searching"
    } finally {
      this.loadingValue = false
      this.submitTarget.disabled = false
    }
  }

  autocomplete(address) {
    this.cityFieldTarget.value = address.admin_ward
    this.postcodeFieldTarget.value = address.postcode
    this.postcodeTarget.value = ""
  }

  selectAddress(event) {
    const addressData = JSON.parse(event.currentTarget.dataset.address)

    // Fill in the form fields
    this.cityFieldTarget.value = addressData.admin_district
    this.postcodeFieldTarget.value = addressData.postcode

    // Hide the results
    this.resultTarget.classList.add("hidden")

    // Clear the search field
    this.postcodeTarget.value = ""
  }

  renderAddress(address) {
    return `
      <div class="mt-3">
        <h4 class="text-sm font-medium text-gray-900">Select an address</h4>
        <ul class="mt-2 divide-y divide-gray-200 border-t border-b border-gray-200">
            <li class="flex cursor-pointer hover:bg-gray-50 py-2" 
                data-action="click->address-lookup#selectAddress" 
                data-address='${JSON.stringify(address)}'>
              <span class="text-sm text-gray-800">${address.postcode + ', ' + address.admin_ward + ', ' + address.region}</span>
            </li>
        </ul>
      </div>
    `
  }

  loadingValueChanged() {
    this.submitTarget.textContent = this.loadingValue ? "Searching..." : "Find Address"
  }
} 