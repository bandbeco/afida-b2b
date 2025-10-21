# frozen_string_literal: true

require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @order = orders(:one)
    @user = users(:one)
    @product = products(:one)
    sign_in @user

    # Create shopping cart with items
    @shopping_cart = @user.create_shopping_cart
    @shopping_cart_item = @shopping_cart.shopping_cart_items.create!(
      product: @product,
      quantity: 2,
      unit_price: 10.0
    )
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    assert_difference("Order.count") do
      params = {
        order: {
          status: "pending",
          payment_method: "invoice",
          shipping_company: "Test Company",
          shipping_attn: "John Doe",
          shipping_street_number_and_name: "123 Test St",
          shipping_post_town: "Test Town",
          shipping_postcode: "TE1 1ST",
          shipping_additional_notes: "Test notes",
          billing_company: "Test Company",
          billing_street_number_and_name: "123 Test St",
          billing_post_town: "Test Town",
          billing_postcode: "TE1 1ST"
        }
      }
      post orders_url, params: params
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show their own order" do
    get order_url(@order)
    assert_response :success
  end

  test "should show their own orders" do
    get orders_url
    assert_response :success
  end
end
