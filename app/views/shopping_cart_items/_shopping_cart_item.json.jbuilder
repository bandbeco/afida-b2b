# frozen_string_literal: true

json.extract! shopping_cart_item, :id, :cart_id, :product_id, :quantity, :created_at, :updated_at
json.url shopping_cart_item_url(shopping_cart_item, format: :json)
