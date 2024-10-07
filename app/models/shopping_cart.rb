class ShoppingCart < ApplicationRecord
  belongs_to :user
  has_many :shopping_cart_items, dependent: :destroy

  def total_amount
    shopping_cart_items.sum(&:total_price)
  end

  def empty?
    shopping_cart_items.added_to_cart.empty?
  end
end
