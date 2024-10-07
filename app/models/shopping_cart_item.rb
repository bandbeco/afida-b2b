class ShoppingCartItem < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product

  validates_numericality_of :quantity, only_integer: true, greater_or_equal_to: 0

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
