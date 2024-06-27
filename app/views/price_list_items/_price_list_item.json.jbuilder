json.extract! price_list_item, :id, :user_id, :product_id, :price, :created_at, :updated_at
json.url price_list_item_url(price_list_item, format: :json)
