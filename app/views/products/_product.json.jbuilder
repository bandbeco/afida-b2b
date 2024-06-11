json.extract! product, :id, :sku, :name, :description, :colour, :pac_size, :price, :width_in_mm, :height_in_mm, :created_at, :updated_at
json.url product_url(product, format: :json)
