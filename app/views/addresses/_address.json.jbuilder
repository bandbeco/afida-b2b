json.extract! address, :id, :building_name, :street_number_and_name, :post_town, :postcode, :additional_notes, :created_at, :updated_at
json.url address_url(address, format: :json)
