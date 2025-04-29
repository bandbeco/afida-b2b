import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="visibility"
export default class extends Controller {
  static targets = ["checkbox", "saveButton"]
  
  originalStates = new Map()
  
  connect() {
    // Immediately disable the save button before anything else
    if (this.hasSaveButtonTarget) {
      this.disableSaveButton()
    }
    
    // Store original checkbox states when controller connects
    this.checkboxTargets.forEach(checkbox => {
      this.originalStates.set(checkbox.value, checkbox.checked)
    })
    
    // Update the select all checkbox state on initial load
    this.updateSelectAllCheckbox()
    
    // Run updateSaveButtonState after a short delay to ensure DOM is fully loaded
    setTimeout(() => {
      this.updateSaveButtonState()
    }, 50)
  }

  toggleAll(event) {
    const isChecked = event.currentTarget.checked
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = isChecked
    })
    
    // Check if this changes the original state
    this.updateSaveButtonState()
  }

  updateSelectAll() {
    this.updateSelectAllCheckbox()
    this.updateSaveButtonState()
  }

  updateSelectAllCheckbox() {
    const selectAllCheckbox = document.getElementById('select-all')
    if (!selectAllCheckbox) return
    
    const allChecked = this.checkboxTargets.length > 0 && 
                      this.checkboxTargets.every(checkbox => checkbox.checked)
    
    selectAllCheckbox.checked = allChecked
  }
  
  updateSaveButtonState() {
    if (!this.hasSaveButtonTarget) return
    
    // Only enable save button if any checkbox has changed from its original state
    const hasChanges = this.checkboxTargets.some(checkbox => {
      const originalState = this.originalStates.get(checkbox.value)
      return checkbox.checked !== originalState
    })
    
    if (hasChanges) {
      this.enableSaveButton()
    } else {
      this.disableSaveButton()
    }
  }
  
  disableSaveButton() {
    this.saveButtonTarget.disabled = true
    this.saveButtonTarget.classList.add('btn-disabled', 'opacity-50', 'cursor-not-allowed')
    this.saveButtonTarget.classList.remove('btn-primary')
  }
  
  enableSaveButton() {
    this.saveButtonTarget.disabled = false
    this.saveButtonTarget.classList.remove('btn-disabled', 'opacity-50', 'cursor-not-allowed')
    this.saveButtonTarget.classList.add('btn-primary')
  }
} 