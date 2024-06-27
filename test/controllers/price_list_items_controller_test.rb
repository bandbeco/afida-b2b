require "test_helper"

class PriceListItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @price_list_item = price_list_items(:one)
  end

  test "should get index" do
    get price_list_items_url
    assert_response :success
  end

  test "should show price_list_item" do
    get price_list_item_url(@price_list_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_price_list_item_url(@price_list_item)
    assert_response :success
  end

  test "should update price_list_item" do
    patch price_list_item_url(@price_list_item), params: { price_list_item: { price: @price_list_item.price, product_id: @price_list_item.product_id, user_id: @price_list_item.user_id } }
    assert_redirected_to price_list_item_url(@price_list_item)
  end
end
