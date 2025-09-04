# frozen_string_literal: true

require 'test_helper'

class CheckoutTest < ActiveSupport::TestCase
  setup do
    @shopping_cart = ShoppingCart.create(user: users(:one))
    @shopping_cart.shopping_cart_items.create!(
      product: products(:one),
      quantity: 5,
      unit_price: 19.00
    )
  end

  test 'vat_amount should be calculated on subtotal plus shipping amount' do
    checkout = Checkout.new(@shopping_cart)
    # With subtotal of 95.00, shipping will be 5.00
    # VAT should be 20% of (95 + 5) = 20.00
    expected_vat = 20.00
    assert_equal expected_vat, checkout.vat_amount
  end
end
