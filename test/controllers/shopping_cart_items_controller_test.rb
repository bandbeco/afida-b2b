require "test_helper"

class ShoppingCartItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shopping_cart_item = shopping_cart_items(:one)
  end

  test "should get index" do
    get shopping_cart_items_url
    assert_response :success
  end

  test "should get new" do
    get new_shopping_cart_item_url
    assert_response :success
  end

  test "should create shopping_cart_item" do
    assert_difference("ShoppingCartItem.count") do
      post shopping_cart_items_url, params: { shopping_cart_item: { shopping_cart_id: @shopping_cart_item.cart_id, product_id: @shopping_cart_item.product_id, quantity: @shopping_cart_item.quantity } }
    end

    assert_redirected_to shopping_cart_item_url(ShoppingCartItem.last)
  end

  test "should show shopping_cart_item" do
    get shopping_cart_item_url(@shopping_cart_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_shopping_cart_item_url(@shopping_cart_item)
    assert_response :success
  end

  test "should update shopping_cart_item" do
    patch shopping_cart_item_url(@shopping_cart_item), params: { shopping_cart_item: { shopping_cart_id: @shopping_cart_item.cart_id, product_id: @shopping_cart_item.product_id, quantity: @shopping_cart_item.quantity } }
    assert_redirected_to shopping_cart_item_url(@shopping_cart_item)
  end

  test "should destroy shopping_cart_item" do
    assert_difference("ShoppingCartItem.count", -1) do
      delete shopping_cart_item_url(@shopping_cart_item)
    end

    assert_redirected_to shopping_cart_items_url
  end
end
