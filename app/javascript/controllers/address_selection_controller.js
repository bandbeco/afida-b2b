import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="address-selection"
export default class extends Controller {
  static values = {
    addresses: Array,
    defaultShippingId: Number,
    defaultBillingId: Number
  }

  static targets = [
    // Shipping fields
    "shippingCompany", "shippingAttn", "shippingBuildingName", "shippingStreet", "shippingCity", "shippingPostcode", "shippingNotes",
    // Billing fields
    "billingCompany", "billingAttn", "billingBuildingName", "billingStreet", "billingCity", "billingPostcode", "billingNotes",
    // Controls
    "shippingFields", "billingSection", "billingFields",
    "saveShippingCheckboxContainer", "saveBillingCheckboxContainer"
  ]

  connect() {
    console.log("AddressSelectionController connected.");
    console.log("Targets found:", this.targetNames);
    console.log("Addresses value:", this.addressesValue);

    // Ensure all potentially relevant sections are hidden *after* connection
    this.hideTarget("shippingFields");
    this.hideTarget("saveShippingCheckboxContainer");
    this.hideTarget("billingFields");
    this.hideTarget("saveBillingCheckboxContainer");

    // Check initial state of dropdowns and show necessary fields
    this.checkInitialSelectState('shipping');
    this.checkInitialSelectState('billing');

    // Apply initial state for billing section visibility based on checkbox
    const useShippingCheckbox = this.element.querySelector('#order_use_shipping_for_billing');
    if (useShippingCheckbox && useShippingCheckbox.checked) {
      this.hideTarget("billingSection");
    } else {
        // If not checked, ensure billing section is visible
        this.showTarget("billingSection");
    }
  }

  checkInitialSelectState(type) {
    const selectElement = this.element.querySelector(`#order_selected_${type}_address_id`);
    if (!selectElement) return;
    const selectedId = selectElement.value;
    console.log(`Initial state for ${type}: ${selectedId}`);

    const fieldsTargetName = `${type}Fields`;
    const checkboxContainerTargetName = `save${this.capitalize(type)}CheckboxContainer`;

    if (selectedId === 'new') {
      this.clearFields(type);
      this.showTarget(fieldsTargetName);
      this.showTarget(checkboxContainerTargetName);
    } else if (selectedId && selectedId !== '') {
      const address = this.findAddressById(parseInt(selectedId, 10));
      if (address) this.populateFields(type, address); 
      // Fields and checkbox container remain hidden (already hidden in connect)
    } else {
      // Blank selected, fields and checkbox container remain hidden
    }
  }

  selectShippingAddress(event) {
    const selectedId = event.target.value;
    console.log("Shipping select changed:", selectedId); // Log change
    this.handleSelectChange('shipping', selectedId);
  }

  selectBillingAddress(event) {
    const selectedId = event.target.value;
    console.log("Billing select changed:", selectedId); // Log change
    this.handleSelectChange('billing', selectedId);
  }

  handleSelectChange(type, selectedId) {
    console.log(`Handling select change for ${type} with ID: ${selectedId}`);
    const fieldsTarget = this[`${type}FieldsTarget`];
    const checkboxContainerTarget = this[`save${this.capitalize(type)}CheckboxContainerTarget`];

    if (!fieldsTarget || !checkboxContainerTarget) {
        console.error(`Targets not found for type: ${type}`);
        return;
    }

    if (selectedId === 'new') {
      console.log(`Showing fields and checkbox for ${type}`);
      this.clearFields(type);
      this.show(fieldsTarget);
      this.show(checkboxContainerTarget);
    } else if (selectedId && selectedId !== '') {
      console.log(`Hiding fields and checkbox for ${type}, populating hidden fields.`);
      const address = this.findAddressById(parseInt(selectedId, 10));
      if (address) {
        this.populateFields(type, address);
      }
      this.hide(fieldsTarget);
      this.hide(checkboxContainerTarget);
    } else {
      console.log(`Hiding fields and checkbox for ${type} (blank selected)`);
      this.clearFields(type);
      this.hide(fieldsTarget);
      this.hide(checkboxContainerTarget);
    }
  }

  toggleBillingFields(event) {
    console.log("Toggling billing fields, checked:", event.target.checked);
    if (event.target.checked) {
      this.hideTarget("billingSection");
    } else {
      this.showTarget("billingSection");
      // Re-evaluate billing select state when showing section
      const selectedBillingId = this.element.querySelector('#order_selected_billing_address_id').value;
      this.handleSelectChange('billing', selectedBillingId);
    }
  }

  // --- Helper Methods ---

  findAddressById(id) {
    return this.addressesValue.find(addr => addr.id === id);
  }

  populateFields(type, address) {
    this.setValue(`${type}Company`, address.company);
    if (this.hasTarget(`${type}Attn`)) {
      this.setValue(`${type}Attn`, address.attn);
    }
    if (this.hasTarget(`${type}BuildingName`)) {
      this.setValue(`${type}BuildingName`, address.building_name);
    }
    this.setValue(`${type}Street`, address.street_number_and_name);
    this.setValue(`${type}City`, address.post_town);
    this.setValue(`${type}Postcode`, address.postcode);
    if (this.hasTarget(`${type}Notes`)) {
      this.setValue(`${type}Notes`, address.additional_notes);
    }
  }

  clearFields(type) {
    this.setValue(`${type}Company`, "");
    if (this.hasTarget(`${type}Attn`)) {
       this.setValue(`${type}Attn`, "");
    }
     if (this.hasTarget(`${type}BuildingName`)) {
       this.setValue(`${type}BuildingName`, "");
     }
    this.setValue(`${type}Street`, "");
    this.setValue(`${type}City`, "");
    this.setValue(`${type}Postcode`, "");
    if (this.hasTarget(`${type}Notes`)) {
       this.setValue(`${type}Notes`, "");
     }
  }

  // Helper to set value safely checking for target existence
  setValue(targetName, value) {
    const target = this[`${targetName}Target`];
    if (target) {
      target.value = value || ""; // Handle null/undefined
    }
  }

  // Helper to check if target exists
  hasTarget(targetName) {
    return this.targets.find(targetName) !== undefined;
  }

  hide(element) {
    if (element) element.classList.add("hidden");
  }

  show(element) {
    if (element) element.classList.remove("hidden");
  }

  capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }

  hideTarget(targetName) {
    if (this.hasTarget(targetName)) {
        this.hide(this[`${targetName}Target`]);
    } else {
        console.warn(`Target not found for hiding: ${targetName}`);
    }
  }

  showTarget(targetName) {
    if (this.hasTarget(targetName)) {
        this.show(this[`${targetName}Target`]);
    } else {
        console.warn(`Target not found for showing: ${targetName}`);
    }
  }
} 