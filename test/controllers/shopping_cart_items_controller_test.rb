# frozen_string_literal: true

require "test_helper"

class ShoppingCartItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @shopping_cart = @user.create_shopping_cart
    @shopping_cart_item = @shopping_cart.shopping_cart_items.create!(
      unit_price: 100,
      product: products(:one),
      quantity: 1
    )
  end

  test "should add to cart" do
    patch add_to_cart_shopping_cart_item_url(@shopping_cart_item, format: :json)
    assert_response :success
    @shopping_cart_item.reload
    assert_equal 2, @shopping_cart_item.quantity
  end

  test "should remove from cart" do
    patch remove_from_cart_shopping_cart_item_url(@shopping_cart_item, format: :json)
    assert_response :success
    @shopping_cart_item.reload
    assert_equal 0, @shopping_cart_item.quantity
  end
end
