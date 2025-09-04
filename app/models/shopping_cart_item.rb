# frozen_string_literal: true

class ShoppingCartItem < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :added_to_cart, -> { where('quantity > 0') }

  def total_price
    quantity * unit_price.to_d.round(2)
  end

  def attributes
    {
      product_id: product_id,
      quantity: quantity,
      unit_price: unit_price
    }
  end
end
