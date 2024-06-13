json.extract! order, :id, :status, :total_amount, :shipping_address, :billing_address, :payment_method, :shipping_method, :created_at, :updated_at
json.url order_url(order, format: :json)
