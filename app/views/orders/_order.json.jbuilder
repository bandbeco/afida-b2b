# frozen_string_literal: true

json.extract! order, :id, :status, :total_amount, :shipping_address, :billing_address, :created_at, :updated_at
json.url order_url(order, format: :json)
