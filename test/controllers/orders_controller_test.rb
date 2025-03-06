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
          subtotal_amount: 20.0,
          shipping_amount: 5.0,
          vat_amount: 5.0,
          total_amount: 30.0,
          shipping_address: {
            company: "Test Company",
            attn: "John Doe",
            street_number_and_name: "123 Test St",
            post_town: "Test Town",
            postcode: "TE1 1ST",
            additional_notes: "Test notes"
          },
          billing_address: {
            company: "Test Company",
            street_number_and_name: "123 Test St",
            post_town: "Test Town",
            postcode: "TE1 1ST"
          }
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
