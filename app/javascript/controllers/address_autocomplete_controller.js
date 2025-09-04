import { Controller } from "@hotwired/stimulus"
import getAddress from "components/getAddress-autocomplete-3.0.9"

export default class extends Controller {
  connect() {
    console.log("Address Autocomplete Controller connected");
    this.enableAutocomplete();
  }

  enableAutocomplete = async ()=>
    {
        await getAddress.autocomplete('address_street_number_and_name', 'token_hEDzcyiWMr367jvqbWDoJ24S6Der_ZJlBe7R_4i530U3ZC__K6s5sY1eyhADhPZynvKrSYEvJvlcw9HcO3dvW2SD519kyaZLp00_Zw5fKsGcAcOwLh9HdJC7lXMr-kmwuNDmScS5mnoKJwAUGooTCfT63avurJC5TbaweYkeQHhss_IPukPwxSzK3r_fVIu6WzoHmB5Y_nQvMetEJarCYg',
        {
            selected : (address)=>{
                document.getElementById('address_street_number_and_name').value = address.formatted_address[0];
                document.getElementById('address_building_name').value = address.formatted_address[1];
                document.getElementById('address_post_town').value = address.formatted_address[2];
                document.getElementById('address_postcode').value = address.postcode;
            }
        });
    }
}