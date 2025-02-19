class Checkout
  SHIPPING_FEE = 5.00
  VAT_RATE = 0.20

  attr_reader :shopping_cart

  def initialize(shopping_cart)
    @shopping_cart = shopping_cart
  end

  def subtotal_amount
    shopping_cart.shopping_cart_items.sum do |item|
      item.quantity * item.unit_price
    end
  end

  def shipping_amount
    subtotal_amount > 100 ? 0 : 5.00
  end

  def vat_amount
    (subtotal_amount + shipping_amount) * VAT_RATE
  end

  def quantities
    shopping_cart.shopping_cart_items.sum(&:quantity)
  end

  def total_amount
    subtotal_amount + vat_amount + shipping_amount
  end

  def attributes
    {
      subtotal_amount: subtotal_amount,
      shipping_amount: shipping_amount,
      vat_rate: VAT_RATE,
      vat_amount: vat_amount,
      total_amount: total_amount
    }
  end
end
